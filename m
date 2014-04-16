Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaDPCGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:06:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:16831 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaDPCGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:06:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,868,1389772800"; 
   d="scan'208";a="521367659"
Message-ID: <534DE589.5020408@linux.intel.com>
Date: Tue, 15 Apr 2014 19:06:01 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, smap]  general protection fault: fff2 [#1] PREEMPT DEBUG_PAGEALLOC
References: <53477D33.8030809@intel.com> <20140411141727.GA14997@localhost>
In-Reply-To: <20140411141727.GA14997@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 07:17 AM, Fengguang Wu wrote:
> Sorry, but I suspect this commit may well be innocent and merely
> _discloses_ an existing bug.
> 
> Because dmesgs for the parent commit all(*) stop here, long before being able
> to emit the "reboot: machine restart" and the general protection fault.
> 
> (*) "all" means all the machines that run qemu "-cpu Haswell,+smep,+smap".
> 
> [  562.353714] Failed to execute /init (error -14)
> [  562.400008] Starting init: /sbin/init exists but couldn't execute it (error -14)
> [  562.400008] Starting init: /etc/init exists but couldn't execute it (error -13)
> [  562.422116] Starting init: /bin/sh exists but couldn't execute it (error -14)
> [  562.450049] Kernel panic - not syncing: No working init found.  Try passing init= option to kernel. See Linux Documentation/init.txt for guidance.
> [  562.450049] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-rc1-00171-g03bbd59 #1
> [  562.450049]  0000000000000000 ffff880012035ec0 ffffffff81380af6 ffff880012035f38
> [  562.450049]  ffffffff8137e608 ffffffff00000008 ffff880012035f48 ffff880012035ee8
> [  562.450049]  0000000000000000 ffffffff81067fcf 0000000000000001 0000000000000000
> [  562.450049] Call Trace:
> [  562.450049]  [<ffffffff81380af6>] dump_stack+0x19/0x1b
> [  562.450049]  [<ffffffff8137e608>] panic+0xcb/0x1ca
> [  562.450049]  [<ffffffff81067fcf>] ? console_unlock+0x319/0x336
> [  562.450049]  [<ffffffff8137778d>] ? rest_init+0xc1/0xc1
> [  562.450049]  [<ffffffff8137785e>] kernel_init+0xd1/0xd5
> [  562.450049]  [<ffffffff81386d3a>] ret_from_fork+0x7a/0xb0
> [  562.450049]  [<ffffffff8137778d>] ? rest_init+0xc1/0xc1
> [  562.450049] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> 

That makes sense, because without that patch any SMAP-based machine
would be known broken.

	-hpa


