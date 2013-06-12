Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab3FLSbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:31:22 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:19582
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019Ab3FLSbU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:31:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Wed, 12 Jun 2013 13:31:11 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] MDIO: FSL_PQ_MDIO: Fix bug on incorrect offset of tbipa
 register
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Oded Gabbay <ogabbay@advaoptical.com>, <stef.van.os@prodrive.nl>,
        <timur@tabi.org>, <Dongsheng.Wang@freescale.com>, <paulus@samba.org>,
        <netdev@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <B38951@freescale.com>
References: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com>
	<51B88EED.6090709@linutronix.de>
In-Reply-To: <51B88EED.6090709@linutronix.de> (from bigeasy@linutronix.de on
	Wed Jun 12 10:08:29 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1371061871.18413.44@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 10:08:29 AM, Sebastian Andrzej Siewior wrote:
> On 06/12/2013 02:47 PM, Oded Gabbay wrote:
> > This patch fixes a bug in the fsl_pq_mdio.c module and in relevant  
> device-tree
> > files regarding the correct offset of the tbipa register in the  
> eTSEC
> > controller in some of Freescale's PQ3 and QorIQ SoC.
> > The bug happens when the mdio in the device tree is configured to  
> be compatible
> > to "fsl,gianfar-tbi". Because the mdio device in the device tree  
> points to
> > addresses 25520, 26520 or 27520 (depends on the controller ID), the  
> variable
> > priv->map at function fsl_pq_mdio_probe, points to that address.  
> However,
> > later in the function there is a write to register tbipa that is  
> actually
> > located at 25030, 26030 or 27030. Because the correct address is  
> not io mapped,
> > the contents are written to a different register in the controller.
> > The fix sets the address of the mdio device to start at 25000,  
> 26000 or 27000
> > and changes the mii_offset field to 0x520 in the relevant entry
> > (fsl,gianfar-tbi) of the fsl_pq_mdio_match array.
> >
> > Note: This patch may break MDIO functionallity of some old  
> Freescale's SoC
> > until Freescale will fix their device tree files. Basically, every  
> device tree
> > which contains an mdio device that is compatible to  
> "fsl,gianfar-tbi" should be
> > examined.
> 
> Not as is.
> Please add a check for the original address. If it has 0x520 at the  
> end
> print a warning and fix it up. Please add to the patch description
> which register is modified instead if this patch is not applied.
> Depending on how critical this it might has to go stable.

I'm not sure it's stable material if this is something that has never  
worked...

The device tree binding will also need to be fixed to note the  
difference in "reg" between "fsl,gianfar-mdio" and "fsl-gianfar-tbi" --  
and should give an example of the latter.

-Scott
