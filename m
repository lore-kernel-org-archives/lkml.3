Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaK2RxE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:53:04 -0500
Received: from imap.thunk.org ([74.207.234.97]:58052 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbaK2RxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:53:01 -0500
Date: Sat, 29 Nov 2014 12:52:55 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix suboptimal seek_{data,hole} extents traversial
Message-ID: <20141129175255.GC4362@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <87egu7k6ym.fsf@openvz.org>
 <1413552334-32240-1-git-send-email-dmonakhov@openvz.org>
 <20141125211433.GB28449@thunk.org>
 <873893id1x.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873893id1x.fsf@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 06:02:02PM +0300, Dmitry Monakhov wrote:
> FYI: inline_data feature is fatally broken

Thanks for finding the bugs!

> 2) ext4_inline_data_fiemap(0 ignores start and len arguments from ext4_filemap()
>    which obviously result in endless loop for anyone who want to use
>    fiemap for inline files (which my patch try to do)

Would this have been triggered using filefrag?  I just checked and
noticed we don't have a filefrag test in xfstests; of course it would
be impossible to test other than the filefrag -v command successfully
completed, but maybe it might be worth adding such a test.

	       	     	      	       	      	   - Ted
