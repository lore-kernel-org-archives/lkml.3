Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaHHQrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:47:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36820 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaHHQrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:41 -0400
Date: Fri, 8 Aug 2014 17:47:37 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Juri Lelli <Juri.Lelli@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] cpuidle/cpuidle-big_little: fix reading cpu id part
 number
Message-ID: <20140808164737.GB11623@e102568-lin.cambridge.arm.com>
References: <1407501757-15231-1-git-send-email-juri.lelli@arm.com>
 <20140808132105.GB30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20140808132105.GB30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Aug 2014 16:47:38.0096 (UTC) FILETIME=[763F5700:01CFB328]
X-MC-Unique: 114080817473900701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 02:21:05PM +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 08, 2014 at 01:42:37PM +0100, Juri Lelli wrote:
> > Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part number
> > correctly") changed ARM_CPU_PART_X masks, and the way they are returned and
> > checked against. Usage of read_cpuid_part_number() is now deprecated, and
> > calling places updated accordingly. This actually broke cpuidle-big_little
> > initialization, as bl_idle_driver_init() performs a check using and hardcoded
> > mask on cpu_id.
> > 
> > Update the check to reflect changes on ARM_CPU_PART_X masks. Also,
> > make the check easier to understand.
> 
> I don't like this "let's work out our own way to check the CPU type"
> stuff which people seem to create.  Let's try and do the job better
> and have some proper interfaces to do this kind of thing.
> 
> Maybe we should have smp_cpuid_part(cpu) which returns the CPU vendor/
> part identifier for the particular CPU in an efficient manner.

Ok, basically an inline function that either read and mask the cpuid
stashed at boot in cpu_data or read the part number straight away on UP.

Should it belong in asm/smp_plat.h ?

Thanks,
Lorenzo

