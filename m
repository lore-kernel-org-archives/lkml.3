Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbbAYOjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:39:46 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35637 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbbAYOjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:39:45 -0500
Message-ID: <54C5002C.4050600@linaro.org>
Date: Sun, 25 Jan 2015 15:39:40 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep Holla <Sudeep.Holla@arm.com>,
        lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] : cpuidle-big.little fix when mcpm is not available
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

This pull request has a single patch which is a fix for the 
cpuidle-big.little driver. If the mcpm backend is not available because 
the CCI is not defined in the DT, the cpuidle driver will 
unconditionally assume it is and call the mcpm functions leading to a 
kernel WARNING.

Sudeep Holla fixed that by checking at the init time the mcpm is 
available before initializing the deeper idle states.

Thanks
   -- Daniel

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

   Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

   http://git.linaro.org/people/daniel.lezcano/linux.git cpuidle/3.20

for you to fetch changes up to 194fe6f28e2819d3f50fbed24c3b72f21501dbfa:

   drivers: cpuidle: Don't initialize big.LITTLE driver if MCPM is 
unavailable (2015-01-23 15:05:48 +0100)

----------------------------------------------------------------
Sudeep Holla (1):
       drivers: cpuidle: Don't initialize big.LITTLE driver if MCPM is 
unavailable

  drivers/cpuidle/cpuidle-big_little.c | 4 ++++
  1 file changed, 4 insertions(+)

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

