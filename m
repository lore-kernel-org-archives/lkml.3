Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3IRUlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:41:21 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:9302
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231Ab3IRUlR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:41:17 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Wed, 18 Sep 2013 13:41:01 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>, Hyun Kwon <hyunk@xilinx.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] clk: si570: Add a driver for SI570 oscillators
References: <1379033737-30015-1-git-send-email-soren.brinkmann@xilinx.com>
 <1379033737-30015-2-git-send-email-soren.brinkmann@xilinx.com>
 <52373314.5070806@wwwdotorg.org>
 <20130916164927.GB21352@roeck-us.net>
 <5237390E.5070203@wwwdotorg.org>
 <20130916173540.GA3481@roeck-us.net>
 <52374FF7.8040604@wwwdotorg.org>
 <52380BD5.8080105@gmail.com>
 <52387FC9.1080905@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52387FC9.1080905@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3551eb15-319d-4304-b213-2b0d9672419b@AM1EHSMHS019.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:14:01AM -0600, Stephen Warren wrote:
> On 09/17/2013 01:59 AM, Sebastian Hesselbarth wrote:
> > On 09/16/2013 08:37 PM, Stephen Warren wrote:
> ...
> >> Perhaps if clock-frequency is specified, the driver should refuse to
> >> provide anything else. If clock-frequency isn't specified, the driver
> >> shouldn't touch the HW when it initializes, but should honor any
> >> requests that come in from other drivers? That would maintain what I
> >> feel is clock-frequency's connection to being a fixed clock.
> > 
> > For the clk-si5351 programmable clock driver in mainline, it already
> > uses "clock-frequency" for initial clock setup but allows to set it
> > later on. IMHO that is ok, because from a initial point-of-view, an
> > initial frequency is fixed. As soon as the driver takes over, the user
> > is free to do whatever he wants and should not be limited by DT.
> > 
> > But if we vote against that approach, we should probably also modifiy
> > clk-si5351 accordingly.
> 
> I suppose that approach isn't unreasonable. So, if there's precedent for
> it, this driver may as well follow it.

All right, this sounds the most flexible to me and requires the least
changes as well :).
I think all I have to change for v2 in regards of this, is to rename the
property to 'clock-frequency'. I'll do that and send out v2 later today.

	Sören


