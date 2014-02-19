Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaBSCMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 21:12:45 -0500
Received: from [216.32.181.181] ([216.32.181.181]:43860 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751312AbaBSCMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 21:12:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 19 Feb 2014 10:12:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@kernel.org>, <festevam@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pfuze100-regulator: Revert "regulator: pfuze100: Use
 of_get_child_by_name"
Message-ID: <20140219021246.GK15716@S2101-09.ap.freescale.net>
References: <1392738636-29877-1-git-send-email-fabio.estevam@freescale.com>
 <CAK9yfHykaoap7Dz+fsZgReRoXW_GsKvmZX7RDGqknd1_o3R50g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK9yfHykaoap7Dz+fsZgReRoXW_GsKvmZX7RDGqknd1_o3R50g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 09:58:52PM +0530, Sachin Kamat wrote:
> On 18 February 2014 21:20, Fabio Estevam <fabio.estevam@freescale.com> wrote:
> > Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
> > the following probe failure:
> >
> > pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
> > pfuze100-regulator 1-0008: FAB: 0, FIN: 0
> > pfuze100-regulator 1-0008: regulators node not found
> > pfuze100-regulator: probe of 1-0008 failed with error -22
> >
> > Revert the offending commit so that we can probe the regulator successfully.
> 
> I wonder what is different in this case from the ones that I already
> have working
> that is causing this to fail. Can you please tell me which dts file
> you have used
> so that I can see if the way the node is defined is anything different.

When you change to use of_get_child_by_name(), you should change 'np' to
point to dev->of_node too.

Shawn

