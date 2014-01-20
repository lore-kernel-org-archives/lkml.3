Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaATHHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 02:07:30 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43507 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaATHH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 02:07:28 -0500
Date: Mon, 20 Jan 2014 08:07:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        bp@suse.de, linux-kernel@vger.kernel.org, sherry.hurwitz@amd.com,
        hmh@hmh.eng.br, Kim.Naru@amd.com, Suravee.Suthikulpanit@amd.com
Subject: Re: [PATCH] x86, quirks: Add workaround for AMD F16h Erratum792
Message-ID: <20140120070724.GA31940@gmail.com>
References: <1389983973-3965-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389983973-3965-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com> wrote:

> The workaround for this Erratum is included in AGESA. But BIOSes spun
> only after Jan2014 will have the fix (atleast server versions of the
> chip). The erratum affects both client and server platforms and since
> we cannot say with certainity that ALL BIOSes on systems out in the
> field will have the fix, we should probably insulate ourselves in case
> BIOS does not do the right thing or someone is using old BIOSes.
> 
> Refer Revision Guide for AMD F16h models 00h-0fh, document 51810
> Rev. 3.04, November2013 for details on the Erratum.
> 
> Tested the patch on Fam16h server platform and works fine.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  arch/x86/kernel/quirks.c |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index 04ee1e2..e55ae02 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -571,3 +571,34 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
>  			quirk_amd_nb_node);
>  
>  #endif
> +
> +#if defined(CONFIG_PCI)
> +/*
> + * Apply AMD Fam16h Erratum792
> + * see Revision Guide for AMD F16h models 00h-0fh,
> + * document 51810 rev. 3.04, Nov 2013
> + */
> +static void quirk_amd_dram_scrub(struct pci_dev *dev)

The reference to the erratum is useful for people who want to see more 
details, but at least a short description of the problem being fixed 
and systems affected by the quirk is needed. 'DRAM scrub' is not very 
informative.

Thanks,

	Ingo
