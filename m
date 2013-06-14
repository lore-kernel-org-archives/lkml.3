Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3FNUSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:18:22 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:37165
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116Ab3FNUSV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:18:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
Date: Fri, 14 Jun 2013 15:18:03 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2] powerpc/pci: Fix setup of Freescale PCI / PCIe
 controllers
To: Rojhalat Ibrahim <imr@rtschenk.de>
CC: Michael Guntsche <michael.guntsche@it-loops.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <2819373.IXRuYOYOkX@pcimr> (from imr@rtschenk.de on Fri Jun 14
	04:05:34 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1371241083.2996.7@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 04:05:34 AM, Rojhalat Ibrahim wrote:
> Commit 50d8f87d2b3 (powerpc/fsl-pci Make PCIe hotplug work with  
> Freescale
> PCIe controllers) does not handle non-PCIe controllers properly,  
> which causes
> a panic during boot for certain configurations.
> This patch fixes the issue by calling setup_indirect_pci for all  
> device types.
> fsl_indirect_read_config is now only used for booke/86xx PCIe  
> controllers.
> 
> Reported-by: Michael Guntsche <mike@it-loops.com>
> Cc: Scott Wood <scottwood@freescale.com>
> Signed-off-by: Rojhalat Ibrahim <imr@rtschenk.de>
> ---
> v2: Make it more consistent.
> 
>  arch/powerpc/sysdev/fsl_pci.c |   20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_pci.c  
> b/arch/powerpc/sysdev/fsl_pci.c
> index 028ac1f..5682c8a 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -97,20 +97,12 @@ static int fsl_indirect_read_config(struct  
> pci_bus *bus,
> unsigned int devfn,
>  	return indirect_read_config(bus, devfn, offset, len, val);
>  }
> 
> -static struct pci_ops fsl_indirect_pci_ops =
> +static struct pci_ops fsl_indirect_pcie_ops =
>  {
>  	.read = fsl_indirect_read_config,
>  	.write = indirect_write_config,
>  };

On 83xx:
cc1: warnings being treated as errors
/home/scott/fsl/git/linux/upstream/arch/powerpc/sysdev/fsl_pci.c:100:23:  
error: 'fsl_indirect_pcie_ops' defined but not used
make[2]: *** [arch/powerpc/sysdev/fsl_pci.o] Error 1
make[2]: *** Waiting for unfinished jobs....

I can fix this when applying, but this makes me wonder how you tested  
it, given that the whole point is to fix 83xx...  Did you fix this and  
then accidentally sent a stale version?

Also, please be careful that the patch doesn't get line wrapped -- I  
had to manually unwrap a couple places.  Use git send-email if you  
can't get KMail to cooperate.

-Scott
