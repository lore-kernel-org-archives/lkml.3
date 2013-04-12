Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3DLPnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab3DLPnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:43:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 03/33] gadget: remove only user of aio retry
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
	<1363883754-27966-4-git-send-email-koverstreet@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Apr 2013 11:42:43 -0400
In-Reply-To: <1363883754-27966-4-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Thu, 21 Mar 2013 09:35:24 -0700")
Message-ID: <x49ppxzu558.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> From: Zach Brown <zab@redhat.com>
>
> This removes the only in-tree user of aio retry.  This will let us remove
> the retry code from the aio core.
>
> Removing retry is relatively easy as the USB gadget wasn't using it to
> retry IOs at all.  It always fully submitted the IO in the context of the
> initial io_submit() call.  It only used the AIO retry facility to get the
> submitter's mm context for copying the result of a read back to user
> space.  This is easy to implement with use_mm() and a work struct, much
> like kvm does with async_pf_execute() for get_user_pages().
>
> Signed-off-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Asai Thambi S P <asamymuthupa@micron.com>
> Cc: Selvan Mani <smani@micron.com>
> Cc: Sam Bradshaw <sbradshaw@micron.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
