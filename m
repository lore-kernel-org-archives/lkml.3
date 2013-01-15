Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3AOCdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:33:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:28921 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab3AOCdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:33:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,469,1355126400"; 
   d="scan'208";a="243827052"
Message-ID: <50F4C027.1080806@intel.com>
Date: Tue, 15 Jan 2013 10:34:15 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: li guang <lig.fnst@cn.fujitsu.com>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>  <1357375071-11793-6-git-send-email-alex.shi@intel.com>  <20130109182102.GC2046@e103034-lin>  <50EF9B69.3000201@linux.vnet.ibm.com>  <1357891316.2860.6.camel@liguang.fnst.cn.fujitsu.com>  <50F02823.1070909@intel.com> <1358154191.8818.15.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1358154191.8818.15.camel@liguang.fnst.cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 05:03 PM, li guang wrote:
>>> > > This corner case may occur after "[PATCH v3 03/22] sched: fix
>>> > > find_idlest_group mess logical" brought in the local sched_group bias,
>>> > > and assume balancing runs on cpux2.
>>> > > ideally,  find_idlest_group should find the real idlest(this case: sgy),
>>> > > then, this patch is reasonable.
>>> > > 
>> > 
>> > Sure. but seems it is a bit hard to go down the idlest group.
>> > 
>> > and the old logical is real cost too much, on my 2 socket NHM/SNB
>> > server, hackbench can increase 2~5% performance. and no clean
>> > performance on kbuild/aim7 etc.
> what about remove local group bias?


Any theory profit for non local group? Usually, bias toward local group
will has cache locality profit.

-- 
Thanks Alex
