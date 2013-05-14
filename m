Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab3ENPcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3ENPcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:32:50 -0400
Date: Tue, 14 May 2013 17:28:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130514152836.GA21972@redhat.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-5-git-send-email-koverstreet@google.com> <20130514145932.GA6607@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514145932.GA6607@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Tejun Heo wrote:
>
> > +int percpu_ref_tryget(struct percpu_ref *ref)
> > +{
> > +	int ret = 1;
> > +
> > +	preempt_disable();
> > +
> > +	if (!percpu_ref_dead(ref))
> > +		percpu_ref_get(ref);
> > +	else
> > +		ret = 0;
> > +
> > +	preempt_enable();
> > +
> > +	return ret;
> > +}
...
> BTW, why is this
> function necessary?  What's the use case?

Yes, I was wondering too.

And please note that this code _looks_ wrong, percpu_ref_get() still
can increment ref->count.

Hmm. Just noticed this comment above percpu_ref_kill()

	* The caller must issue a synchronize_rcu()/call_rcu() before calling
	* percpu_ref_put() to drop the initial ref.

Really?

Oleg.

