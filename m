Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaJQCZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 22:25:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:31668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbaJQCZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 22:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,735,1406617200"; 
   d="scan'208";a="620257718"
Date: Fri, 17 Oct 2014 10:25:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: [cpufreq] 48ed83b84da: scaling_governor write error
Message-ID: <20141017022547.GA8005@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Viresh,

FYI, our test script is broken by a commit from you:

https://git.linaro.org/people/vireshk/linux cpufreq/governor-fixes
commit 48ed83b84da331d010c5bd10b9d2f72d5308bddd ("cpufreq: Track governor-state to disallow invalid state requests")


ee46f1592843a04d  48ed83b84da331d010c5bd10b9 
----------------  -------------------------- 
       fail:runs  %reproduction    fail:runs
           |             |             |
           :5          100%           5:5     TOTAL stderr./lkp/lkp/src/setup/cpufreq_governor:line#:echo:write_error:Invalid_argument

The error messages are:

 /lkp/wfg/src/setup/cpufreq_governor: line 9: echo: write error: Device or resource busy
 /lkp/wfg/src/setup/cpufreq_governor: line 9: echo: write error: Device or resource busy
 /lkp/wfg/src/setup/cpufreq_governor: line 9: echo: write error: Device or resource busy

where the cpufreq_governor script is
 
        #!/bin/bash

        scaling_governor=$1
        [[ $scaling_governor ]] || exit 0

        for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
        do
                note "echo $scaling_governor > $file"
==>             echo $scaling_governor > $file
        done

Thanks,
Fengguang

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor

--rwEMma7ioTxnRzrJ--
