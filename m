Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3KGEzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:55:07 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:16116
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab3KGEzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:55:04 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579ehz98dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 7 Nov 2013 12:55:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rongjun Ying <Rongjun.Ying@csr.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, rjying <rjying@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Barry Song <Barry.Song@csr.com>
Subject: Re: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead
 of voltage-tolerance
Message-ID: <20131107045540.GE5994@S2101-09.ap.freescale.net>
References: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
 <CAKohpo=qR5WD=5VjGmeRraQ+_m5NUn8xiP5Z_ZuZWLv1hNx5KA@mail.gmail.com>
 <20131105115307.GN19770@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F44947801295423DF@SHAASIEXM01.ASIA.ROOT.PRI>
 <20131106032742.GP19770@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F44947801295427BD@SHAASIEXM01.ASIA.ROOT.PRI>
 <20131107022639.GB5994@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F4494780129542816@SHAASIEXM01.ASIA.ROOT.PRI>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86130EF012BDF348AA0D464A4F4494780129542816@SHAASIEXM01.ASIA.ROOT.PRI>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 03:32:09AM +0000, Rongjun Ying wrote:
> I think my patch is better.

Well, unfortunately your patch is plainly wrong, because there are
in-tree users of voltage-tolerance right now.  How can you simply remove
it from driver with ignoring these users?

$ git grep voltage-tolerance arch/arm/boot/dts
arch/arm/boot/dts/am33xx.dtsi:                  voltage-tolerance = <2>; /* 2 percentage */
arch/arm/boot/dts/imx27.dtsi:                   voltage-tolerance = <5>;
arch/arm/boot/dts/r8a73a4-ape6evm-reference.dts:        voltage-tolerance = <1>; /* 1% */
arch/arm/boot/dts/r8a73a4-ape6evm.dts:  voltage-tolerance = <1>; /* 1% */
arch/arm/boot/dts/sh73a0-kzm9g-reference.dts:                   voltage-tolerance = <1>; /* 1% */

Shawn

> All soc have a max work voltage. If regulator IC can't supply min voltage, 
> It can supply max voltage to soc.
> As my patch, not need overwrite OPP in <board>.dts.
> As your comment above, almost all board need overwrite OPP, unless the regulator 
> IC can supply all voltage ranges of SoC need.

