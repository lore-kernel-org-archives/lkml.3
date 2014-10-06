Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaJFCnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 22:43:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:34287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaJFCnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 22:43:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,661,1406617200"; 
   d="scan'208";a="482151904"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "acme@kernel.org" <acme@kernel.org>
Subject: RE: [PATCH V7 0/4] perf tools: pmu event new style format fix
Thread-Topic: [PATCH V7 0/4] perf tools: pmu event new style format fix
Thread-Index: AQHP3yU8ye24dRfDF0CSzgiH3UTGPJwhWvcAgAEE4KA=
Date: Mon, 6 Oct 2014 02:42:53 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770160B586@SHSMSX103.ccr.corp.intel.com>
References: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
 <20141005190802.GC1934@krava.redhat.com>
In-Reply-To: <20141005190802.GC1934@krava.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > Kan Liang (4):
> >   Revert "perf tools: Default to cpu// for events v5"
> >   perf tools: parse the pmu event prefix and suffix
> >   perf tools: Add support to new style format of kernel PMU event
> >   perf tools: Add test case for pmu event new style format
> 
> got test failure with your patchset:
> 

The test passed on my machine. 
It looks your test failed with test 13/14. But my patch should not impact these two cases. Could you please double check?
(I also manually test 13 and 14, they all passed on my machine.)

[root@localhost perf]# ./perf test parse -v
 5: parse events tests                                     :
--- start ---
test child forked, pid 6966
running test 0 'syscalls:sys_enter_open'
running test 1 'syscalls:*'
running test 2 'r1a'
running test 3 '1:1'
running test 4 'instructions'
running test 5 'cycles/period=100000,config2/'
running test 6 'faults'
running test 7 'L1-dcache-load-miss'
running test 8 'mem:0'
running test 9 'mem:0:x'
running test 10 'mem:0:r'
running test 11 'mem:0:w'
running test 12 'syscalls:sys_enter_open:k'
running test 13 'syscalls:*:u'
running test 14 'r1a:kp'

SNIP

running test 39 '{instructions,branch-misses}:Su'
running test 40 'instructions:uDp'
running test 41 '{cycles,cache-misses,branch-misses}:D'
running test 0 'cpu/config=10,config1,config2=3,period=1000/u'
running test 1 'cpu/config=1,name=krava/u,cpu/config=2/u'
running test 0 'config=10,config1,config2=3,umask=1'
test child finished with 0
---- end ----
parse events tests: Ok

Kan 

> [jolsa@krava perf]$ sudo ./perf test parse -v
>  5: parse events tests                                     :
> --- start ---
> test child forked, pid 9972
> running test 0 'syscalls:sys_enter_open'
> registering plugin: /root/.traceevent/plugins/plugin_kvm.so
> registering plugin: /root/.traceevent/plugins/plugin_scsi.so
> registering plugin: /root/.traceevent/plugins/plugin_mac80211.so
> registering plugin: /root/.traceevent/plugins/plugin_hrtimer.so
> 
> SNIP
> 
> running test 6 'faults'
> running test 7 'L1-dcache-load-miss'
> running test 8 'mem:0'
> running test 9 'mem:0:x'
> running test 10 'mem:0:r'
> running test 11 'mem:0:w'
> running test 12 'syscalls:sys_enter_open:k'
> running test 13 'syscalls:*:u'
> test child interrupted
> ---- end ----
> parse events tests: FAILED!
> 
> 
> jirka
