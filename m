Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab3APB4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:56:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757289Ab3APB4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:56:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,476,1355068800"; 
   d="scan'208";a="6594807"
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in
 fork/exec/wake
From: li guang <lig.fnst@cn.fujitsu.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
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
In-Reply-To: <50F4C027.1080806@intel.com>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	 <1357375071-11793-6-git-send-email-alex.shi@intel.com>
	 <20130109182102.GC2046@e103034-lin>  <50EF9B69.3000201@linux.vnet.ibm.com>
	 <1357891316.2860.6.camel@liguang.fnst.cn.fujitsu.com>
	 <50F02823.1070909@intel.com>
	 <1358154191.8818.15.camel@liguang.fnst.cn.fujitsu.com>
	 <50F4C027.1080806@intel.com>
Date: Wed, 16 Jan 2013 09:54:40 +0800
Message-ID: <1358301280.23348.6.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 09:55:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/16 09:56:01,
	Serialize complete at 2013/01/16 09:56:01
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-01-15二的 10:34 +0800，Alex Shi写道：
> On 01/14/2013 05:03 PM, li guang wrote:
> >>> > > This corner case may occur after "[PATCH v3 03/22] sched: fix
> >>> > > find_idlest_group mess logical" brought in the local sched_group bias,
> >>> > > and assume balancing runs on cpux2.
> >>> > > ideally,  find_idlest_group should find the real idlest(this case: sgy),
> >>> > > then, this patch is reasonable.
> >>> > > 
> >> > 
> >> > Sure. but seems it is a bit hard to go down the idlest group.
> >> > 
> >> > and the old logical is real cost too much, on my 2 socket NHM/SNB
> >> > server, hackbench can increase 2~5% performance. and no clean
> >> > performance on kbuild/aim7 etc.
> > what about remove local group bias?
> 
> 
> Any theory profit for non local group? Usually, bias toward local group
> will has cache locality profit.
> 

but the disadvantage is miss correct balance sometime,
if mostly like you said before it will bring in better performance,
that's fine, I have no strong statistic to do more profound analysis.


-- 
regards!
li guang

