Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3KGDiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:38:51 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:34809 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3KGDit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:38:49 -0500
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Thu, 07 Nov 2013 11:38:44 +0800
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
Thread-Index: AQHO2dSzt4p89ClR/0iIszhVSF2c8ZoVh94AgAB5jYCAAXZxwP//jq4AgAH7uDD//4WOgIAAk9vw
Date: Thu, 7 Nov 2013 03:32:09 +0000
Message-ID: <86130EF012BDF348AA0D464A4F4494780129542816@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1383621014-11202-1-git-send-email-rongjun.ying@csr.com>
 <CAKohpo=qR5WD=5VjGmeRraQ+_m5NUn8xiP5Z_ZuZWLv1hNx5KA@mail.gmail.com>
 <20131105115307.GN19770@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F44947801295423DF@SHAASIEXM01.ASIA.ROOT.PRI>
 <20131106032742.GP19770@S2101-09.ap.freescale.net>
 <86130EF012BDF348AA0D464A4F44947801295427BD@SHAASIEXM01.ASIA.ROOT.PRI>
 <20131107022639.GB5994@S2101-09.ap.freescale.net>
In-Reply-To: <20131107022639.GB5994@S2101-09.ap.freescale.net>
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
> Sent: Thursday, November 07, 2013 10:27 AM
> To: Rongjun Ying
> Cc: Viresh Kumar; rjying; Rafael J. Wysocki; cpufreq@vger.kernel.org;
> linux-pm@vger.kernel.org; Linux Kernel Mailing List; Barry Song
> Subject: Re: [PATCH 1/1] cpufreq: cpufreq-cpu0: use the max voltage
> instead of voltage-tolerance
> 
> On Thu, Nov 07, 2013 at 01:55:21AM +0000, Rongjun Ying wrote:
> > > For given board, what voltages could be provided is known.  So you
> > > can just define OPP table in <board>.dts and specify the voltage as
> > > the value that the regulator IC can supply, e.g. 1.200V in above
> example.
> > >
> > > This is not nice, as OPP table is CPU/SoC specific and should be
> > > ideally defined in <soc>.dtsi.  But still it's a way out for you to
> > > use
> > > cpufreq-cpu0 driver as it is.
> > >
> > > In any case, you can not just change voltage-tolerance to
> > > voltage-max with no care about the existing users.
> > >
> > > Shawn
> > >
> > I don't think so. The voltage/freq pairs are attribute of the CPU.
> > Any boards can choose regulator IC base the cost and other reasons.
> > If the opp table defined in <board>.dts, we can set exact
> voltage/freq
> > pairs, and not need use the voltage-tolerance to set tolerance.
> 
> If you read my comment above, you should see that I agree OPP is
> CPU/SoC specific and should be defined in <soc>.dtsi.  But property
> operating-points can reasonably be overwritten by particular
> <board>.dts for some reason like some voltages cannot be supplied on
> that board.
> 
> Again, this is just a way for you to use generic cpufreq-cpu0 driver as
> it is, but not necessarily the best one.
> 
> Shawn
> 

I think my patch is better.
All soc have a max work voltage. If regulator IC can't supply min voltage, 
It can supply max voltage to soc.
As my patch, not need overwrite OPP in <board>.dts.
As your comment above, almost all board need overwrite OPP, unless the regulator 
IC can supply all voltage ranges of SoC need.

Thanks
-RongJun Ying
> 
> 
>  To report this email as spam click
> https://www.mailcontrol.com/sr/MZbqvYs5QwJvpeaetUwhCQ==
> aM23S6+s5uWr7qEkawiSK+0AUqjCk0gm6KMeRLY+cWrx9g== .


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
