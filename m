Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249Ab3LIB4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:56:33 -0500
Received: from imap.thunk.org ([74.207.234.97]:37874 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab3LIB43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:56:29 -0500
Date: Sun, 8 Dec 2013 20:56:28 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: fix del_timer() misuse for ->s_err_report
Message-ID: <20131209015628.GA12883@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <20131204072926.GK10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204072926.GK10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 07:29:26AM +0000, Al Viro wrote:
> That thing should be del_timer_sync(); consider what happens
> if ext4_put_super() call of del_timer() happens to come just as it's
> getting run on another CPU.  Since that timer reschedules itself
> to run next day, you are pretty much guaranteed that you'll end up
> with kfree'd scheduled timer, with usual fun consequences.  AFAICS,
> that's -stable fodder all way back to 2010... [the second del_timer_sync()
> is almost certainly not needed, but it doesn't hurt either]
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Nice catch.  Thanks, applied.

						- Ted
