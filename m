Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3IWLF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:05:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:36447 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab3IWLFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:05:53 -0400
Date: Mon, 23 Sep 2013 07:05:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, hpa@zytor.com,
        joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH, RFC 07/12] random: allow architectures to optionally
 define random_get_entropy()
Message-ID: <20130923110531.GI7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	hpa@zytor.com, joern@logfs.org, macro@linux-mips.org,
	ralf@linux-mips.org, dave.taht@gmail.com, blogic@openwrt.org,
	andrewmcgr@gmail.com, geert@linux-m68k.org, tg@mirbsd.de
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
 <1379882338-7209-8-git-send-email-tytso@mit.edu>
 <1436634.TJZIP2QOy7@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1436634.TJZIP2QOy7@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:38:26PM +0200, Stephan Mueller wrote:
> 
> Are there any plans to get such function implemented on large list of 
> architectures without a get_cycles function?

For some architectures, yes.  As John Stultz pointed out, on many of
the older embedded platforms (which are many of the ones with out a
get_cycles function), the only clocksource they have is the jiffies
time source anyway.  So I'd much rather take each architecture one at
a time, and fix them right.

						- Ted
