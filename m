Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaHOQc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:32:27 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34299 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaHOQcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:32:24 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Juri Lelli <juri.lelli@arm.com>
Cc: linux@arm.linux.org.uk, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Will Deacon <will.deacon@arm.com>, Chao Xie <chao.xie@marvell.com>,
        Stephen Warren <swarren@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Chao Xie Linux <xiechao.mail@gmail.com>,
        Juri Lelli <juri.lelli@gmail.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cpuidle/cpuidle-big_little: fix reading cpu id part number
References: <1408004865-27525-1-git-send-email-juri.lelli@arm.com>
Date: Fri, 15 Aug 2014 09:32:16 -0700
In-Reply-To: <1408004865-27525-1-git-send-email-juri.lelli@arm.com> (Juri
	Lelli's message of "Thu, 14 Aug 2014 09:27:45 +0100")
Message-ID: <7hwqa9ww6n.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juri Lelli <juri.lelli@arm.com> writes:

> Commit af040ffc9ba1 ("ARM: make it easier to check the CPU part number
> correctly") changed ARM_CPU_PART_X masks, and the way they are returned and
> checked against. Usage of read_cpuid_part_number() is now deprecated, and
> calling places updated accordingly. This actually broke cpuidle-big_little
> initialization, as bl_idle_driver_init() performs a check using an hardcoded
> mask on cpu_id.
>
> Create an interface to perform the check (that is now even easier to read).
> Define also a proper mask (ARM_CPU_PART_MASK) that makes this kind of checks
> cleaner and helps preventing bugs in the future. Update usage accordingly.

[...]

Tested-by: Kevin Hilman <khilman@linaro.org>

FWIW, I can confirm that this patch is needed for cpuidle-big_little to
work on the Exynos5800/Chromebook2.

Kevin
