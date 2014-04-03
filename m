Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaDCOdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:33:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64681 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaDCOcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:32:48 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-93-533d710feb29
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Loc Ho <lho@apm.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH libata/for-3.15-fixes] libata: drop COMPILE_TEST from
 AHCI_XGENE
Date: Thu, 03 Apr 2014 16:32:24 +0200
Message-id: <1975949.1ZaeyAUAJz@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140402162215.GC16631@htj.dyndns.org>
References: <20140401184916.GA21938@kroah.com>
 <20140402155357.GA16631@htj.dyndns.org> <20140402162215.GC16631@htj.dyndns.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jQV3+Qttgg8f7eCzmrF/DZtG8eD2b
	xYWnPWwWLbd6WSwu75rDZrFoWSuzxa/lRxktHvW9ZXfg8Pi4/hOjx6ZVnWweJ2b8ZvHYP3cN
	u8fxG9uZPD5vkgtgi+KySUnNySxLLdK3S+DKuND3krHghEjF/49nWRsYNwp0MXJySAiYSMxt
	6WKCsMUkLtxbz9bFyMUhJDCdUWLK9M+sEE4Lk8TpFydYQKrYBKwkJravYgSxRQRkJa5Me8gI
	UsQssJpJ4lPXD7BRwgJhEhNmnGMDsVkEVCW6GvaANfMKaEqs3jcHrEZUwFNix/aVYDWcQGfc
	OnMXanUDo8SHJY/YIRoEJX5MvgfWzCwgL7Fv/1RWCFtLYv3O40wTGAVmISmbhaRsFpKyBYzM
	qxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCw/+Z9A7GVQ0WhxgFOBiVeHg50m2DhVgTy4or
	cw8xSnAwK4nwHksECvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl
	4uCUamBkFHnqOZF7a/rKRpnt1tLZbOrZrKpb03LcT0Yc0jyQL2D5ysw3WfleXRTzs3shS4wu
	Tn+8doaV/Gou0cjvTr9rA//qCe+Qi5B9ODvVSyX9ixL/rhXfYl+b7vQV5oxy4zwyW7Xt4ZJG
	43lVccdPfvvxc6P4UcX1Oa789R3ybfZZy63fzX1mxqbEUpyRaKjFXFScCAChoH3iewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, April 02, 2014 12:22:15 PM Tejun Heo wrote:
> On Wed, Apr 02, 2014 at 11:53:57AM -0400, Tejun Heo wrote:
> > Applied the following patch to libata/for-3.15-fixes.
> > 
> > Thanks.
> > ------- 8< -------
> > From 9c23f2cf7f6e107e85eef57fdf3049a93b6e157c Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Wed, 2 Apr 2014 11:47:04 -0400
> > 
> > AHCI_XGENE is only applicable on ARM64 but it can also be enabled for
> > compile testing; however, AHCI_XGENE selects PHY_XGENE which has other
> > arch specific dependencies.  This leads to the following warning when
> > enabling it on other archs for compile testing.
> > 
> >   warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
> >   dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
> > 
> > Let's drop COMPILE_TEST from AHCI_XGENE.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Loc Ho <lho@apm.com>
> > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> 
> So, apparently, this isn't enough as this would allow enabling
> PHY_XGENE regardless of HAS_IOMEM or OF.  From kconfig-language.txt,

PHY_XGENE has the following dependencies:

	depends on HAS_IOMEM && OF && (ARM64 || COMPILE_TEST)

So it should be OK.

>    Note:
> 	select should be used with care. select will force
> 	a symbol to a value without visiting the dependencies.
> 	By abusing select you are able to select a symbol FOO even
> 	if FOO depends on BAR that is not set.
> 	In general use select only for non-visible symbols
> 	(no prompts anywhere) and for symbols with no dependencies.
> 	That will limit the usefulness but on the other hand avoid
> 	the illegal configurations all over.
> 
> We can add all the necessary dependencies to AHCI_XGENE but I think
> the the right thing to do is turning it into a proper dependency.

Please note that ARM64 implies that HAS_IOMEM and OF are _always_
selected.  This is the reason why removing "|| COMPILE_TEST" from
AHCI_XGENE dependencies is sufficient to fix the issue (though
I have to admit that relying indirectly on ARM64 selects is a bit
hacky).

> Will prep another patch.

Hmmm, the alternative idea is to remove PHY_XGENE reference from
AHCI_XGENE altogether and add:

	default y if AHCI_XGENE

to PHY_XGENE instead (which seems to be not as hacky as solution
with "select PHY_XGENE" and also more user-friendly than "depends
on PHY_XGENE" one).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

