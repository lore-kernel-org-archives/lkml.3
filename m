Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbaDVUkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:40:15 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:41157 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbaDVUkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:40:10 -0400
Date: Tue, 22 Apr 2014 16:40:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, toshi.kani@hp.com
Subject: Re: [RFC PATCH v5 1/2] Use lock_device_hotplug() in
 cpu_probe_store() and cpu_release_store()
Message-ID: <20140422204006.GA3615@mtj.dyndns.org>
References: <20140414201315.GD16835@htj.dyndns.org>
 <1397529877.13188.68.camel@ThinkPad-T5421.cn.ibm.com>
 <20140415145017.GK1863@htj.dyndns.org>
 <1397612500.13188.83.camel@ThinkPad-T5421.cn.ibm.com>
 <20140416151749.GE1257@htj.dyndns.org>
 <1397717444.4034.15.camel@ThinkPad-T5421>
 <20140417151728.GK15326@htj.dyndns.org>
 <1398072059.2755.41.camel@ThinkPad-T5421.cn.ibm.com>
 <20140421223804.GD22730@htj.dyndns.org>
 <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398133777.2805.7.camel@ThinkPad-T5421.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 22, 2014 at 10:29:37AM +0800, Li Zhong wrote:
> The probe/release files are attribute files for cpu subsys, looks like
> following in sysfs dirs
> 
> $ cd /sys/devices/system/cpu/
> $ ls -l
> total 0
> drwxr-xr-x. 7 root root     0 Apr 17 19:00 cpu0
> drwxr-xr-x. 4 root root     0 Apr 17 19:00 cpu1
> drwxr-xr-x. 4 root root     0 Apr 17 19:00 cpu10
> ......
> drwxr-xr-x. 3 root root     0 Apr 20 08:00 cpufreq
> drwxr-xr-x. 2 root root     0 Apr 20 08:00 cpuidle
> -rw-------. 1 root root 65536 Apr 21 00:28 dscr_default
> -r--r--r--. 1 root root 65536 Apr 21 00:28 kernel_max
> -r--r--r--. 1 root root 65536 Apr 21 00:28 offline
> -r--r--r--. 1 root root 65536 Sep  4  2014 online
> -r--r--r--. 1 root root 65536 Apr 21 00:28 possible
> drwxr-xr-x. 2 root root     0 Apr 20 08:00 power
> -r--r--r--. 1 root root 65536 Apr 17 20:46 present
> --w-------. 1 root root 65536 Apr 21 00:28 probe        <-----	
> --w-------. 1 root root 65536 Apr 21 00:28 release      <-----
> -rw-------. 1 root root 65536 Apr 21 00:28 subcores_per_core
> -rw-r--r--. 1 root root 65536 Apr 21 00:28 uevent
> 
> From the code, it seems cpu subsys won't be unregistered, and it doesn't
> make sense to remove all the cpus in the system. 

I don't think I'm following you.  Are you saying that no files which
are protected under the hotplug lock that cpu subsys uses are removed
during offlining?

Thanks.

-- 
tejun
