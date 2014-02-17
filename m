Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaBQMXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 07:23:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaBQMXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 07:23:51 -0500
Message-Id: <201402171223.s1HCNG0S023567@userz7022.oracle.com>
Date: Mon, 17 Feb 2014 07:23:13 -0500
Subject: Re: [PATCH] xen: remove XEN_PRIVILEGED_GUEST
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Ingo Molnar <mingo@redhat.com>, xen-devel@lists.xenproject.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1HCNuQD017238


On Feb 16, 2014 3:07 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>
> This patch removes the Kconfig symbol XEN_PRIVILEGED_GUEST which is 
> used nowhere in the tree. We do know grub2 has a script that greps 
> kernel configuration files for this symbol. It shouldn't do that. As

Please look in the grub git tree. They have fixed their code to not do this anymore. This should be reflected in the patch description.

Lastly please check which distro has this new grub version so that we know which distros won't be affected.

Thanks.

> Linus summarized: 
> Â Â Â  This is a grub bug. It really is that simple. Treat it as one. 
>
> So there's no reason to not remove it, like we do with all unused 
> Kconfig symbols. 
>
> [pebolle@tiscali.nl: rewrote commit explanation.] 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl> 
> --- 
> Tested with "git grep". 
>
> Michael's version can be found at https://lkml.org/lkml/2013/7/8/34 . 
> (This is the same patch, with a rewritten explanation, and my S-o-b 
> line.) The question whether this symbol can be removed was further 
> discussed in https://lkml.org/lkml/2013/7/15/308 . 
>
> I don't think a bug was ever filed against grub2 regarding its way to 
> check for Xen support. Should that be done first?

Had been done the moment I got Linus reply but instead of a bug it was on the mailing list.
>
> arch/x86/xen/Kconfig | 5 ----- 
> 1 file changed, 5 deletions(-) 
>
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig 
> index 01b9026..512219d 100644 
> --- a/arch/x86/xen/Kconfig 
> +++ b/arch/x86/xen/Kconfig 
> @@ -19,11 +19,6 @@ config XEN_DOM0 
> depends on XEN && PCI_XEN && SWIOTLB_XEN 
> depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI 
>
> -# Dummy symbol since people have come to rely on the PRIVILEGED_GUEST 
> -# name in tools. 
> -config XEN_PRIVILEGED_GUEST 
> - def_bool XEN_DOM0 
> - 
> config XEN_PVHVM 
> def_bool y 
> depends on XEN && PCI && X86_LOCAL_APIC 
> -- 
> 1.8.5.3 
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
