Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3D0O1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 10:27:51 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46357 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3D0O1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 10:27:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org, dirk.j.brandewie@intel.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: CONFIG_X86_INTEL_PSTATE disables CPU frequency transition stats, many governors and other standard features
Date: Sat, 27 Apr 2013 16:35:59 +0200
Message-ID: <1843018.F0kGJi5K1v@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc8+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <475427035.74642.1367038733183.JavaMail.mail@webmail08>
References: <475427035.74642.1367038733183.JavaMail.mail@webmail08>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 27, 2013 04:58:53 AM Artem S. Tashkinov wrote:
> Hello,
> 
> Just wanted to let everyone know that CONFIG_X86_INTEL_PSTATE wreaks
> havoc with the CPU frequency subsystem in the Linux kernel.
> 
> With this option enabled:
> 
> 1) All governors except performance and powersave are gone, ondemand
> userspace, conservative
> 
> 2) scaling_cur_freq is gone, thus user space utilities monitoring the CPU
> frequency have stopped working
> 
> 3) CPU frequency transition stats are gone, there's no "stats" directory
> anywhere
> 
> 4) scaling_available_frequencies is gone, so I cannot set the desired constant
> CPU frequency (the userspace governor is not available anyway)
> 
> Is this an intended behavior? I shrivel to think that's the case.
> 
> The bug report is filed here: https://bugzilla.kernel.org/show_bug.cgi?id=57141

intel_pstate is not a usual cpufreq driver and from the cpufreq's perspective
it contains its own governor.  That's the reason why the other scaling governors
aren't available with it.

The sysfs attributes mentioned above are missing simply because they don't make
sense with intel_pstate.

I'm only wondering which user space doesn't work correctly with intel_pstate as
you said in the bug entry above.

If you don't want to use intel_pstate (in which case the ACPI driver will be
used instead), please append intel_pstate=disable to the kernel command line.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
