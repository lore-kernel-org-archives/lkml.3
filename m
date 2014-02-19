Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBSEiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:38:00 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:57810 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaBSEh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:37:58 -0500
Message-ID: <53043521.4060206@gmail.com>
Date: Wed, 19 Feb 2014 05:37:53 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Intel Corporation <linux.nics@intel.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>
Subject: Re: WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 dev_watchdog+0x276/0x280()
References: <530332B7.10909@gmail.com>
In-Reply-To: <530332B7.10909@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.02.2014 11:15, poma wrote:
> 
> Ahoy!
> 
> Debugging S3 aka suspend produces 'WARNINGS':
> 
> Steps to Reproduce:
> # echo core > /sys/power/pm_test
> # cat /sys/power/pm_test
> none [core] processors platform devices freezer
> # echo mem > /sys/power/state
> Results:
> - dmesg-3.14.0-0.rc3.git0.1.fc21.x86_64+debug-pm_test-core.diff
>   https://bugzilla.redhat.com/attachment.cgi?id=864436
> 
> Steps to Reproduce:
> # echo processors > /sys/power/pm_test
> # cat /sys/power/pm_test
> none core [processors] platform devices freezer
> # echo mem > /sys/power/state
> Results:
> - dmesg-3.14.0-0.rc3.git0.1.fc21.x86_64+debug-pm_test-processors.diff
>   https://bugzilla.redhat.com/attachment.cgi?id=864438
> 
> Steps to Reproduce:
> # echo platform > /sys/power/pm_test
> # cat /sys/power/pm_test
> none core processors [platform] devices freezer
> # echo mem > /sys/power/state
> Results:
> - dmesg-3.14.0-0.rc3.git0.1.fc21.x86_64+debug-pm_test-platform.diff
>   https://bugzilla.redhat.com/attachment.cgi?id=864439
> 
> RHBZ 1010764:
> "[abrt] NETDEV WATCHDOG: em1 (e1000e): transmit queue 0 timed out"
> https://bugzilla.redhat.com/show_bug.cgi?id=1010764
> 
> Tested with Rawhide 'kernel-debug-3.14.0-0.rc3.git0.1.fc21.x86_64'
> http://koji.fedoraproject.org/koji/buildinfo?buildID=498711

A comparison of 'RealTek RTL-8169 GE' & 'SysKonnect GE'

Debugging S3 - core:
# echo core > /sys/power/pm_test
# echo mem > /sys/power/state
  RTL8169:
- dmesg-3.14.0-0.rc3.git2.1.fc21.x86_64-r8169-pm_test-core.diff
  https://bugzilla.redhat.com/attachment.cgi?id=864959
  SKGE:
- dmesg-3.14.0-0.rc3.git2.1.fc21.x86_64-skge-pm_test-core.diff
  https://bugzilla.redhat.com/attachment.cgi?id=864960

Debugging S3 - processors:
# echo processors > /sys/power/pm_test
# echo mem > /sys/power/state
  RTL8169:
- dmesg-3.14.0-0.rc3.git2.1.fc21.x86_64-r8169-pm_test-processors.diff
  https://bugzilla.redhat.com/attachment.cgi?id=864961
  SKGE:
- dmesg-3.14.0-0.rc3.git2.1.fc21.x86_64-skge-pm_test-processors.diff
  https://bugzilla.redhat.com/attachment.cgi?id=864962

Debugging S3 - platform:
# echo platform > /sys/power/pm_test
# echo mem > /sys/power/state
  RTL8169:
- dmesg-3.14.0-0.rc3.git2.1.fc21.x86_64-r8169-pm_test-platform.diff
  https://bugzilla.redhat.com/attachment.cgi?id=864963
  SKGE:
- dmesg-3.14.0-0.rc3.git2.1.fc21.x86_64-skge-pm_test-platform.diff
  https://bugzilla.redhat.com/attachment.cgi?id=864964

RHBZ
https://bugzilla.redhat.com/show_bug.cgi?id=1010764

Tested with Rawhide ' kernel-3.14.0-0.rc3.git2.1.fc21.x86_64'
http://koji.fedoraproject.org/koji/buildinfo?buildID=499061


poma

