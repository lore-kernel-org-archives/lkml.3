Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbbAMKP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:15:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbAMKPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:15:55 -0500
Date: Tue, 13 Jan 2015 10:16:14 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.2-stable] Suspend regression after "x86, 64bit, mm: Mark
 data/bss/brk to nx"
Message-ID: <20150113101614.GC2304@charon>
References: <1420935783.2327.28.camel@decadent.org.uk>
 <1421010983.19708.20.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421010983.19708.20.camel@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 09:16:23PM +0000, Ben Hutchings wrote:
> On Sun, 2015-01-11 at 00:23 +0000, Ben Hutchings wrote:
> > Commit 45e2a9d4701d8c624d4a4bcdd1084eae31e92f58 ("x86, mm: Set NX across
> > entire PMD at boot") has been backported to many stable branches:
> > 
> > v3.10.62: 0b15c16c4f4a x86, mm: Set NX across entire PMD at boot
> > v3.12.35: 868b19cb0314 x86, mm: Set NX across entire PMD at boot
> > v3.14.26: 1a829c59816e x86, mm: Set NX across entire PMD at boot
> > v3.17.5: 6231385167e0 x86, mm: Set NX across entire PMD at boot
> > v3.2.65: a5c187d92d2c x86, mm: Set NX across entire PMD at boot
> > v3.13.11-ckt12: 3657489f7009 x86, mm: Set NX across entire PMD at boot
> > v3.16.7-ckt3: de32229b546e x86, mm: Set NX across entire PMD at boot
> 
> Sorry, I think I booted the wrong version at the last step of bisection.
> It was actually the previous commit on the 3.2.y branch, which was
> commit 72212675d1c96f5db8ec6fb35701879911193158 upstream ("x86, 64bit,
> mm: Mark data/bss/brk to nx") that introduced the regression.  I intend
> to revert both of these.
> 
> Ben.
> 

This is an old (3.8) commit that seems to have been backported to 3.2
as a dependency of 45e2a9d4701d8c624d4a4bcdd1084eae31e92f58 and all
the other stable kernels already included it.  Since I am not aware of
any new regression, I believe this is could be a 3.2 specific issue.

Anyway, thanks a lot for sharing this, as we have an Ubuntu kernel
that is based on 3.2, to which we regularly apply 3.2 releases.

Cheers,
--
Luís

> > Unfortunately, in 3.2.65 suspend/resume stopped working on at least some
> > systems - specifically, the system would reboot when woken:
> > 
> > https://bugs.debian.org/774436 - Lenovo ThinkPad T530
> > https://bugs.debian.org/774461 - Lenovo ThinkPad X230
> > https://bugs.debian.org/774526 - ECS P4M900T-M2
> > https://bugs.debian.org/775059 - ASUS X201EP
> > 
> > I could reproduce this on my own ASUS P8Z68-V LX and was able to bisect
> > to the backport of this commit.
> > 
> > Assuming that this regression has not occurred on mainline or the other
> > branches, I will revert this patch for 3.2.y unless someone can point
> > out a missing dependency that I should apply.
> > 
> > Ben.
> > 
> 
> -- 
> Ben Hutchings
> One of the nice things about standards is that there are so many of them.

