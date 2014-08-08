Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaHHNVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:21:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43890 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752322AbaHHNVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:21:13 -0400
Date: Fri, 8 Aug 2014 14:21:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Juri Lelli <juri.lelli@arm.com>
Cc: linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH] cpuidle/cpuidle-big_little: fix reading cpu id part
	number
Message-ID: <20140808132105.GB30282@n2100.arm.linux.org.uk>
References: <1407501757-15231-1-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407501757-15231-1-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 01:42:37PM +0100, Juri Lelli wrote:
> Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part number
> correctly") changed ARM_CPU_PART_X masks, and the way they are returned and
> checked against. Usage of read_cpuid_part_number() is now deprecated, and
> calling places updated accordingly. This actually broke cpuidle-big_little
> initialization, as bl_idle_driver_init() performs a check using and hardcoded
> mask on cpu_id.
> 
> Update the check to reflect changes on ARM_CPU_PART_X masks. Also,
> make the check easier to understand.

I don't like this "let's work out our own way to check the CPU type"
stuff which people seem to create.  Let's try and do the job better
and have some proper interfaces to do this kind of thing.

Maybe we should have smp_cpuid_part(cpu) which returns the CPU vendor/
part identifier for the particular CPU in an efficient manner.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
