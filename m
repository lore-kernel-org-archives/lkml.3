Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaDBOqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:46:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44888 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaDBOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:46:08 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-a9-533c22ae76c9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Loc Ho <lho@apm.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches for 3.15-rc1
Date: Wed, 02 Apr 2014 16:45:44 +0200
Message-id: <2258562.Li8pOfuGsm@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <533C0B45.4050909@ti.com>
References: <20140401184916.GA21938@kroah.com>
 <CAPw-ZTnb4Ugjo_63HG0DmGaqki6riPk1S13Nx8xF_9gdNu17wA@mail.gmail.com>
 <533C0B45.4050909@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQd11SjbBBss3S1jMWb+GzaJ58Xo2
	iwtPe9gsWm71slhc3jWHzWLRslZmi1/LjzJaPOp7y+7A4fFx/SdGj02rOtk8Tsz4zeKxf+4a
	do/jN7YzeXzeJBfAFsVlk5Kak1mWWqRvl8CV8XvdTOaC1XwVi99NYGxgXM3dxcjJISFgIrHw
	3GpWCFtM4sK99WxdjFwcQgLTGSVeTrkG5bQwSSy51MQGUsUmYCUxsX0VI4gtIqAlcXrnD2YQ
	m1lgDpNE37myLkYODmEBA4m2qw4gYRYBVYm51/uYQGxeAU2JjdengpWLCnhK7Ni+Emwkp4Ca
	RPPDXSwQuyYySnz+cJMRokFQ4sfkeywQ8+Ul9u2fygph60jsb53GNoFRYBaSsllIymYhKVvA
	yLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzj0n0nvYFzVYHGIUYCDUYmH11LKJliINbGs
	uDL3EKMEB7OSCO+kT9bBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQW
	wWSZODilGhgnxL6d+W6ldmfj2mpd1/X3rIK2/FprqvAkuvnQE8X/C3c6anx+8Wjfl7UbNlxV
	kfsZWm4ZseJPsJZ9o9u8E8lB/muPyRxRqVU+tnLXyvJ9l/wOsqdMza5sTtTb/WOdSvEl5/39
	GWeVFjUG8N4J/3Iz79+sM/lO2c8yTlxRFuK83rW7yvb4efv9SizFGYmGWsxFxYkAmG7UbnkC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, April 02, 2014 06:36:13 PM Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Wednesday 02 April 2014 11:12 AM, Loc Ho wrote:
> > Hi,
> > 
> >>>> USB patches for 3.15-rc1
> >>>>
> >>>> Here's the big USB pull request for 3.15-rc1.
> >>>
> >>> Hmm. I'm getting this when testing:
> >>>
> >>>   warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
> >>> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
> >>>
> >>> which looks like AHCI_XGENE doesn't have the proper dependency on OF
> >>> (or alternatively PHY_XGENE has an incorrect dependemcy on OF).
> >>>
> >>> According to google it looks like Fengguang reported this on
> >>> kbuild-all, but nowhere else.
> >>>
> >>> The actual build then succeeds. But the Kconfig warning is real and
> >>> implies that something is seriously wrong wrt the dependencies for
> >>> this thing.
> >>>
> >>> It looks like the "select PHY_XGENE" came in through the libata
> >>> update, but this USB update actually brought in the "config PHY_XGENE"
> >>> and thus this error. Which makes me wonder how this all worked. Why
> >>> does that "select PHY_XGENE" exist when apparently it's not needed?
> >>>
> >>> Regardless, there's something broken somewhere.
> >>
> >> Odd, I don't know what to do to fix this up "properly".
> >>
> >> Loc Ho, this came in from your patch, any ideas?
> 
> Shouldn't we let the users to enable PHY_XGENE (maybe add in the platform
> defconfig)?

The idea that PHY drivers have to be explicitly enabled to make
other drivers work doesn't sound very attractive.  I would prefer
to go with Loc's idea of dropping COMPILE_TEST dependency and
making the AHCI_XGENE driver available only on ARM64.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

