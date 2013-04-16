Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131Ab3DPRss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:48:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965031Ab3DPRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:48:46 -0400
Date: Tue, 16 Apr 2013 19:48:40 +0200
From: Jan Kara <jack@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lsf-pc@lists.linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: New AIO API
Message-ID: <20130416174840.GA15725@quack.suse.cz>
References: <20130412222856.GB31761@localhost>
 <20130415153113.e91625d754cb60c73e60abff@linux-foundation.org>
 <87sj2r6zo4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sj2r6zo4.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-04-13 10:48:35, Rusty Russell wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > On Fri, 12 Apr 2013 15:28:56 -0700 Kent Overstreet <koverstreet@google.com> wrote:
> >> Those are the main changes (besides adding attributes, of course) that
> >> I've made so far. 
> >> 
> >>  * Get rid of the parallel syscall interface 
> >> 
> >>    AIO really shouldn't be implementing its own slightly different
> >>    syscalls; it should be a mechanism for doing syscalls asynchronously.
> >
> > Yes.  We got about a twelfth of the way there many years ago
> > (google("syslets")) but it died.  A shame.
> 
> Yeah, letting the current process keep waiting and creating a new one
> which returns is a fascinating idea, but you really need to swizzle the
> PIDs so that the "new" one is identical to the old.  Otherwise the API
> is unbearable...
  But when we do crazy stuff like pid namespaces these days somehow
switching pids shouldn't be *that* hard... Should it? Just a crazy idea
that occured to me now :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
