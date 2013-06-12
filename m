Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab3FLWFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 18:05:39 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:54531
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755220Ab3FLWFi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 18:05:38 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 18:05:37 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 12 Jun 2013 16:50:26 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
To: Rojhalat Ibrahim <imr@rtschenk.de>
CC: Michael Guntsche <michael.guntsche@it-loops.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
References: <1370971739.18413.27@snotra> <34279395.MbRViMjbAR@pcimr>
In-Reply-To: <34279395.MbRViMjbAR@pcimr> (from imr@rtschenk.de on Wed Jun 12
	03:19:30 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1371073826.18413.52@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 03:19:30 AM, Rojhalat Ibrahim wrote:
> On Tuesday 11 June 2013 12:28:59 Scott Wood wrote:
> > Yes, I figured it was non-PCIe because the code change that you said
> > helped was on the non-PCIe branch of the if/else.  Generally it's  
> good
> > to explicitly mention the chip you're using, though.
> >
> > fsl_setup_indirect_pci should be renamed to fsl_setup_indirect_pcie.
> > Your patch above should be applied, and fsl_setup_indirect_pcie  
> should
> > be moved into the booke/86xx ifdef to avoid an unused function  
> warning.
> >
> > -Scott
> 
> How about this patch? It uses setup_indirect_pci for the PCI case in
> mpc83xx_add_bridge. Additionally it adds a check in  
> fsl_setup_indirect_pci
> to only use the modified read function in case of PCIe.

If we're adding the check to fsl_setup_indirect_pci, there's no need to  
change the 83xx call back to setup_indirect_pci.  I see that 85xx is  
also callirng fsl_setup_indirect_pci for both; it'd be good to be  
consistent.

In any case, can you send a proper patch with a signoff and commit  
message?

-Scott
