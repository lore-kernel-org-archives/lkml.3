Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab3E2Aez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:34:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:6063 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab3E2Aey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:34:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,761,1363158000"; 
   d="scan'208";a="341655575"
Message-ID: <51A54D11.4050407@intel.com>
Date: Tue, 28 May 2013 17:34:25 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: cpu hotplug broken in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I boot with: maxcpus=2 possible_cpus=4

I get

	# grep . /sys/devices/system/cpu/cpu[0-9]*/online'
	/sys/devices/system/cpu/cpu1/online:1
	/sys/devices/system/cpu/cpu2/online:1
	/sys/devices/system/cpu/cpu3/online:1

When 2 and 3 *should* be offline.  I also get -EINVAL if I try to
re-offline them in this state.  2 and 3 don't show up in /proc/cpuinfo,
so sysfs just looks broken here.

I'm bisecting it at the moment, but won't get to finish until tomorrow.
 Just thought I'd report early and often. :)
