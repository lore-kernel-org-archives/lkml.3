Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3KGBzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 20:55:40 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:57111 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KGBzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 20:55:36 -0500
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Thu, 07 Nov 2013 09:55:30 +0800
From: Rongjun Ying <Rongjun.Ying@csr.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>, rjying <rjying@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Barry Song <Barry.Song@csr.com>
Subject: RE: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead
 of voltage-tolerance
Thread-Topic: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage instead
 of voltage-tolerance
Thread-Index: AQHO2dSzt4p89ClR/0iIszhVSF2c8ZoVh94AgAB5jYCAAXZxwP//jq4AgAH7uDA=
Date: Thu, 7 Nov 2013 01:55:21 +0000
Message-ID: <86130EF012BDF348AA0D464A4F44947801295427BD@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
 <CAKohpo=qR5WD=5VjGmeRraQ+_m5NUn8xiP5Z_ZuZWLv1hNx5KA@mail.gmail.com>
 <20131105115307.GN19770@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F44947801295423DF@SHAASIEXM01.ASIA.ROOT.PRI>
 <20131106032742.GP19770@S2101-09.ap.freescale.net>
In-Reply-To: <20131106032742.GP19770@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.5.123]
MIME-Version: 1.0
Content-Language: zh-CN
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Shawn Guo [mailto:shawn.guo@linaro.org]
> Sent: Wednesday, November 06, 2013 11:28 AM
> To: Rongjun Ying
> Cc: Viresh Kumar; rjying; Rafael J. Wysocki; cpufreq@vger.kernel.org;
> linux-pm@vger.kernel.org; Linux Kernel Mailing List;
> rongjun.ying@gcsr.com
> Subject: Re: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage
> instead of voltage-tolerance
> 
> On Wed, Nov 06, 2013 at 02:15:07AM +0000, Rongjun Ying wrote:
> > If omit voltage-tolerance, sometimes also can't get appropriate
> voltages.
> > For example:
> > If the regulator IC only can supply min voltage is 1.000V and max
> voltage is 1.200V, and cpu work max voltage is 1.200V.
> > But the cpu just need 1.100V when cpu run under a freq.
> > So regulator_set_voltage_tol will return failed.
> > Because the regulator_set_voltage will invoke with min-uV is 1100000
> and max-uV is 1100000 parameters.
> > Regulator can't supply it.
> > As this case, the regulator just need supply 1.200V.
> 
> For given board, what voltages could be provided is known.  So you can
> just define OPP table in <board>.dts and specify the voltage as the
> value that the regulator IC can supply, e.g. 1.200V in above example.
> 
> This is not nice, as OPP table is CPU/SoC specific and should be
> ideally defined in <soc>.dtsi.  But still it's a way out for you to use
> cpufreq-cpu0 driver as it is.
> 
> In any case, you can not just change voltage-tolerance to voltage-max
> with no care about the existing users.
> 
> Shawn
> 
I don't think so. The voltage/freq pairs are attribute of the CPU.
Any boards can choose regulator IC base the cost and other reasons.
If the opp table defined in <board>.dts, we can set exact voltage/freq pairs,
and not need use the voltage-tolerance to set tolerance.

Thanks
-RongJun Ying
> 
> 
>  To report this email as spam click
> https://www.mailcontrol.com/sr/MZbqvYs5QwJvpeaetUwhCQ==
> ch0RRg48Kxe8iwle4qrOOz8w5o+DwGNVtWag1M3YVHc55g== .


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
