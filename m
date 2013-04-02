Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab3DBCyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 22:54:07 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58061 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324Ab3DBCyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 22:54:05 -0400
Date: Mon, 1 Apr 2013 22:53:50 -0400
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
Subject: Re: [PATCH 17/33] aio: change reqs_active to include unreaped
 completions
Message-ID: <20130402025350.GF30122@thunk.org>
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
 <1363883754-27966-18-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363883754-27966-18-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 09:35:38AM -0700, Kent Overstreet wrote:
> The aio code tries really hard to avoid having to deal with the completion
> ringbuffer overflowing.  To do that, it has to keep track of the number of
> outstanding kiocbs, and the number of completions currently in the
> ringbuffer - and it's got to check that every time we allocate a kiocb.
> Ouch.
> 
> But - we can improve this quite a bit if we just change reqs_active to
> mean "number of outstanding requests and unreaped completions" - that
> means kiocb allocation doesn't have to look at the ringbuffer, which is a
> fairly significant win.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Could you please add a quick comment documenting the reqs_active field
in the struct kioctx definition here?  For future code
maintainability, it should be documented in fs/aio.c, not just in a
commit description.

>  struct kioctx {
>  	atomic_t		users;
>  	atomic_t		dead;
> @@ -92,7 +86,13 @@ struct kioctx {
>  	atomic_t		reqs_active;
>  	struct list_head	active_reqs;	/* used for cancellation */

	       					   - Ted
