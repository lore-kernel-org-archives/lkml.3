Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaHAKnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:43:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:8773 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaHAKne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:43:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,779,1400050800"; 
   d="scan'208";a="570412103"
Date: Fri, 1 Aug 2014 18:43:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [BUG cpufreq] Invalid argument on writing to scaling_governor
Message-ID: <20140801104314.GA741@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prarit,

I noticed that commit dbcbfe6aa0d61ae5e13cab43b30802482007c199 ("cpufreq: hold
policy->rwsem for duration of changing governors") will cause this problem:

root@nhm4 ~# echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
-bash: echo: write error: Invalid argument

root@nhm4 ~# cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_available_governors
conservative userspace powersave ondemand performance

Thanks,
Fengguang
