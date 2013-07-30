Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3G3Cbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:31:47 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:31385
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab3G3Cbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:31:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzbb2dI98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Tue, 30 Jul 2013 10:36:24 +0800
From: Robin Gong <b38343@freescale.com>
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: regulator: pfuze100: A few small questions
Message-ID: <20130730023623.GB1430@Robin-OptiPlex-780>
References: <1375082774.7272.1.camel@phoenix>
 <CAFRkauB35ERLgakua7=Q+xoRx-N83BTD4f_8HyvbGjAxhEZvUg@mail.gmail.com>
 <20130729092809.GA319@Robin-OptiPlex-780>
 <CAFRkauCKMjNxZatNmOVc95XUuuDNzW0+7razK4tmHKwf+JyS0A@mail.gmail.com>
 <20130730022603.GA1430@Robin-OptiPlex-780>
 <CAFRkauBF3EeCKqkvmt0E9Wifo8GD615X2LzqE59E-YoSVEFMaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAFRkauBF3EeCKqkvmt0E9Wifo8GD615X2LzqE59E-YoSVEFMaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:26:40AM +0800, Axel Lin wrote:
> 2013/7/30 Robin Gong <b38343@freescale.com>:
> > On Mon, Jul 29, 2013 at 11:44:40PM +0800, Axel Lin wrote:
> >> >> Current code adjust min_uV and uV_step when SW2~SW4 high bit is set.
> >> >> I'm wondering if n_voltages is correct or not in this case because
> >> >> the n_voltages is calculated by original equation (max-min/step + 1).
> >> >> What is the max_uV when SW2~SW4 high bit is set?
> >> >>
> >> > If high bit set(bit6, bit0~5:vsel), min_uV/step will change from 0.4V/25mV to
> >> > 0.8V/50mV,but the n_voltages will kept the same.
> >> > For example,SW2 will vary from 0.4V to 1.975V(0x0~0x3f),if bit6 set 0(high bit)
> >> > SW2 will vary from 0.8V to 3.3V(0x40~0x72,0x72~0x7f:reversed).
> >> > Please ignore bit7 or consider it as 0.
> >>
> >> Hi Robin,
> >> According to your description:
> >> BIT6 is clear: 0.4V ~ 1.975V , step 25mV (0x0~0x3f)
> >> BIT6 is set:   0.8V ~ 3.3V, step 50mV    (0x40~0x72,0x72~0x7f:reversed)
> >>
> >> For SW2/SW3A/SW3B/SW4:
> >> I think current implementation is wrong.
> >> The supported voltage range should cover the whole range: 0.4V ~ 3.3V.
> >>
> > Hi Alex,
> Errh... It's "Axel".
> 
Sorry...And thanks for your great catch.
> > Yes,the default setting of SW2 ~SW4in the regulator array is 0.4V~1.975V
> > (Bit6 clear),and my code will check the true setting of Bit6. If Bit6=1
> > I will change min_uV from 0.4V to 0.8V ,step from 25mV to 50mV as what
> > hardware define. I don't think we should mix the two define as what you
> > mean 0.4V~3.3V. Because for every pfuze100 chip, the voltage of SW2~SW4
> > is 0.4V~1.975V or 0.8V~3.3V, not 0.4V~3.3V(from software view,Bit6 only
> > readable).
> Well, if Bit6 is read-only then current code make sense.
> 
> Regards,
> Axel
> 

