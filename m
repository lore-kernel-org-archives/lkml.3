Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3FJWwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:52:43 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:25719 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051Ab3FJWwl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:52:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1be0I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz177df4h17326ah8275eh8275dha1495iz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Mon, 10 Jun 2013 17:52:33 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
To: Michael Guntsche <michael.guntsche@it-loops.com>
CC: Rojhalat Ibrahim <imr@rtschenk.de>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
References: <CALG0vJu9-640D=Q-2RoSOnWtR=sERwj0fSCibK+ijprcf-T6Ag@mail.gmail.com>
	<7927838.NMrLdRWptT@pcimr>
	<CALG0vJtjS2wP_s=-iyG1ABKw_ct=B9OdNXY9YCrnkhAnpaN1Zw@mail.gmail.com>
In-Reply-To: <CALG0vJtjS2wP_s=-iyG1ABKw_ct=B9OdNXY9YCrnkhAnpaN1Zw@mail.gmail.com> (from
	michael.guntsche@it-loops.com on Mon Jun 10 12:07:43 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1370904753.18413.19@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 12:07:43 PM, Michael Guntsche wrote:
> Good evening,
> 
> On Mon, Jun 10, 2013 at 1:41 PM, Rojhalat Ibrahim <imr@rtschenk.de>  
> wrote:
> > Hi Mike,
> >
> > could you please try this patch:
> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-May/106624.html
> > http://patchwork.ozlabs.org/patch/244515/
> >
> >    Rojhalat
> >
> >
> > On Saturday 08 June 2013 21:39:37 Michael Guntsche wrote:
> >> After bisecting I found the responsible commit.
> >>
> >> 50d8f87d2b3: powerpc/fsl-pci Make PCIe hotplug work with Freescale
> >> PCIe controllers
> >>
> >> Reverting this commit allowed my board to boot again.
> >>
> >> @Rojhalat: Please have a look at
> >> http://marc.info/?l=linux-kernel&m=137071294204858&w=2
> >> for my initial bugreport.
> >>
> >> What I do not understand at all is why this is affecting my  
> platform.
> >> AFAIK there is no PCIe hardware on it AND I completely disabled  
> PCIe
> >> support in config.
> >>
> >> Kind regards,
> >> Mike
> 
> This patch does not fix the problem, during boot the kernel still
> panics. I had a closer look at the commit and the following patch
> fixes it for me....
> 
> diff --git a/arch/powerpc/sysdev/fsl_pci.c  
> b/arch/powerpc/sysdev/fsl_pci.c
> index 028ac1f..21b687f 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -814,7 +814,7 @@ int __init mpc83xx_add_bridge(struct device_node  
> *dev)
>                 if (ret)
>                         goto err0;
>         } else {
> -               fsl_setup_indirect_pci(hose, rsrc_cfg.start,
> +               setup_indirect_pci(hose, rsrc_cfg.start,
>                                        rsrc_cfg.start + 4, 0);
>         }

The only difference here is that you're not setting hose->ops to  
fsl_indirect_pci_ops.  Do you know why that is helping, and what  
hose->ops is set to instead?

-Scott
