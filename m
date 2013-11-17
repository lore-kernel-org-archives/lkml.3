Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3KQLfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 06:35:51 -0500
Received: from nebula.mojo.cc ([46.4.89.19]:32885 "EHLO nebula.mojo.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab3KQLfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 06:35:44 -0500
From: "MPhil. Emanoil Kotsev" <Emanoil.Kotsev@fincom.at>
Organization: FinCom Consulting
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [Intel-gfx] kernel 3.11.6 general protection fault
Date: Sun, 17 Nov 2013 12:35:16 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
References: <201311132058.30310.Emanoil.Kotsev@fincom.at> <20131113200914.GG7251@phenom.ffwll.local> <20131113203319.GB23962@pd.tnic>
In-Reply-To: <20131113203319.GB23962@pd.tnic>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201311171235.17602.Emanoil.Kotsev@fincom.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I listened to your advise and installed 3.12 kernel (no other modules on top 
that would taint the kernel like vmware/player). 
So it turned out I have to enable /proc/acpi (depreciated) and acpi_cpufreq, 
so that I may have a proper support for cooling and frequency.

$ acpi -t
Thermal 0: ok, 50.5 degrees C
$ acpi -c
Cooling 0: Processor 0 of 10
Cooling 1: Processor 0 of 10
Cooling 2: LCD 3 of 7
$ lsmod | grep cpu
cpufreq_ondemand        8085  2
cpufreq_powersave        926  0
cpufreq_performance      930  0
cpufreq_conservative     6305  0
acpi_cpufreq            6955  0
processor              23167  3 acpi_cpufreq

After doing all of this I was able to reproduce the issue by overloading the 
system with following simple steps:
1. start a compilation of something (ex. kernel)
2. run another process hungry application (flashplayer in firefox)
=> system locks in about 3-5mins

I also noticed that the board gets pretty hot, so in my opinion it locks 
because of thermal issue.
I think this also would explain why I see errors at different processes 
(mostly Xorg), but with 3.12 I do not get any trace message in the log files.
Could you advise which option should be enabled in the kernel or how I could 
log/trace if system locks.
How can I make sure that the cooling/temp works properly?

Perhaps after upgrading in september the system is working under heavier load 
and therefore I started having the issue, or something broke in software or 
hardware and it can not cool down properly. I don't think the kernel is the 
issue, because I had the same with older kernels that were working fine 
before.
The fan looks clean and there is no dust or whatever in the cooling area, that 
would prevent colling. The physical position of the notebook (docking 
station) also did not change.
I don't know where to look at or to start, so any advise is appreciated.

thanks in advance and kind regards
