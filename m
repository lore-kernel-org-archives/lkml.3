Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab3KFD1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:27:10 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:48997
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050Ab3KFD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:27:08 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579ehz98dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 6 Nov 2013 11:27:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rongjun Ying <Rongjun.Ying@csr.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>, rjying <rjying@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "rongjun.ying@gcsr.com" <rongjun.ying@gcsr.com>
Subject: Re: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead
 of voltage-tolerance
Message-ID: <20131106032742.GP19770@S2101-09.ap.freescale.net>
References: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
 <CAKohpo=qR5WD=5VjGmeRraQ+_m5NUn8xiP5Z_ZuZWLv1hNx5KA@mail.gmail.com>
 <20131105115307.GN19770@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F44947801295423DF@SHAASIEXM01.ASIA.ROOT.PRI>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86130EF012BDF348AA0D464A4F44947801295423DF@SHAASIEXM01.ASIA.ROOT.PRI>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 02:15:07AM +0000, Rongjun Ying wrote:
> If omit voltage-tolerance, sometimes also can't get appropriate voltages.
> For example:
> If the regulator IC only can supply min voltage is 1.000V and max voltage is 1.200V, and cpu work max voltage is 1.200V.
> But the cpu just need 1.100V when cpu run under a freq.
> So regulator_set_voltage_tol will return failed. 
> Because the regulator_set_voltage will invoke with min-uV is 1100000 and max-uV is 1100000 parameters.
> Regulator can't supply it.
> As this case, the regulator just need supply 1.200V.

For given board, what voltages could be provided is known.  So you can
just define OPP table in <board>.dts and specify the voltage as the
value that the regulator IC can supply, e.g. 1.200V in above example.

This is not nice, as OPP table is CPU/SoC specific and should be ideally
defined in <soc>.dtsi.  But still it's a way out for you to use
cpufreq-cpu0 driver as it is.

In any case, you can not just change voltage-tolerance to voltage-max
with no care about the existing users.

Shawn

