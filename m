Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520Ab3DBQDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:03:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58379 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761275Ab3DBQDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:03:35 -0400
Date: Tue, 2 Apr 2013 12:03:17 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 22/33] aio: percpu reqs_available
Message-ID: <20130402160317.GF31577@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-aio@kvack.org,
	akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
	Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
	Asai Thambi S P <asamymuthupa@micron.com>,
	Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
	Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-23-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-23-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:43AM -0700, Kent Overstreet wrote:
> See the previous patch ("aio: reqs_active -> reqs_available") for why we
> want to do this - this basically implements a per cpu allocator for
> reqs_available that doesn't actually allocate anything.
> 
> Note that we need to increase the size of the ringbuffer we allocate,
> since a single thread won't necessarily be able to use all the
> reqs_available slots - some (up to about half) might be on other per cpu
> lists, unavailable for the current thread.
> 
> We size the ringbuffer based on the nr_events userspace passed to
> io_setup(), so this is a slight behaviour change - but nr_events wasn't
> being used as a hard limit before, it was being rounded up to the next
> page before so this doesn't change the actual semantics.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

