Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3G2JXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:23:39 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:32682
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab3G2JXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:23:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzbb2dI98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Mon, 29 Jul 2013 17:28:10 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulator: pfuze100: A few small questions
Message-ID: <20130729092809.GA319@Robin-OptiPlex-780>
References: <1375082774.7272.1.camel@phoenix>
 <CAFRkauB35ERLgakua7=Q+xoRx-N83BTD4f_8HyvbGjAxhEZvUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAFRkauB35ERLgakua7=Q+xoRx-N83BTD4f_8HyvbGjAxhEZvUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 04:20:03PM +0800, Axel Lin wrote:
> 2013/7/29 Axel Lin <axel.lin@ingics.com>:
> > Hi Robin,
> > 2 questions about the code in pfuze100 driver:
> >
> > 1)
> > Both PFUZE100_REVID and PFUZE100_FABID are defined as 0x3.
> > So I'm wondering if it's a typo in one of the register address?
> > If they are actually the same register, we don't need to read the same
> > register twice in pfuze_identify().
Yes, It's a typo, I will correct it.
> >
> > 2)
> > What is the the purpose of stby_reg and stby_mask?
> > Seems current code does not use it?
They are only kept place. These reg bits are used to set standby
voltage, I will finish it in the future.
> 
> 
> One more question:
> 
> Current code adjust min_uV and uV_step when SW2~SW4 high bit is set.
> I'm wondering if n_voltages is correct or not in this case because
> the n_voltages is calculated by original equation (max-min/step + 1).
> What is the max_uV when SW2~SW4 high bit is set?
> 
If high bit set(bit6, bit0~5:vsel), min_uV/step will change from 0.4V/25mV to
0.8V/50mV,but the n_voltages will kept the same.
For example,SW2 will vary from 0.4V to 1.975V(0x0~0x3f),if bit6 set 0(high bit)
SW2 will vary from 0.8V to 3.3V(0x40~0x72,0x72~0x7f:reversed).
Please ignore bit7 or consider it as 0.
> Regards,
> Axel
> 

