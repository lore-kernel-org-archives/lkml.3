Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbbASMLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:11:05 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63249 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbASMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:11:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mach-ux500: board-mop500-regulators.c: Remove unused function
Date: Mon, 19 Jan 2015 11:00:57 +0100
Message-ID: <11128609.Upt8IQGP29@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150118180747.GK3574@x1>
References: <1420126805-28098-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <5939350.DKrZ01egfS@wuerfel> <20150118180747.GK3574@x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:zBFEGp+0NreEiUN7axvMRohLhbFW6IDAxIR85o/HMHF/JK/lA6A
 ef4UdQqF0cph6qY8Dimug2CRCso+Q3dk67Ry+qMPErbMXHI0fVei3xMMAqG/tzQV4VpRGDl
 sKRmfSDSlvrxgabTAnNcenOFCqHIIFCMkDi+DAV8QnBxj5p8EbPsuvpgKox2F19kPSPnt9X
 p51yeFfWjX8Lp4u67GxJQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2015 18:07:47 Lee Jones wrote:
> On Fri, 02 Jan 2015, Arnd Bergmann wrote:
> 
> > On Thursday 01 January 2015 16:40:05 Rickard Strandqvist wrote:
> > > Remove the function mop500_regulator_init() that is not used anywhere.
> > > 
> > > This was partially found by using a static code analysis program called cppcheck.
> > > 
> > > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > 
> > This looks wrong: For one thing, you failed to notice that now another function
> > in the same file becomes unused, or that half of the file is not used
> > anyway.
> > 
> > It also seems that the fact that this function is not called was an accident
> > and it should in fact be called. Maybe Lee has some more insight in this,
> > as he added the function in the first place.
> > 
> > Finally (unrelated to your patch, but triggered by looking at it), I suspect
> > we should just move the ab8500_regulator_plat_data and everything it references
> > to drivers/regulator/ab8500-ext.c, because we only have one instance of it
> > and won't ever have more.
> 
> This is old code.  The development of this stuff was halted before it
> could be finished.  Feel free to remove it and all other unused code
> it uncovers.
> 

Thanks for the confirmation!

Richard, do you feel up to doing the task of the broader cleanup here?

	Arnd
