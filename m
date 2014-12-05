Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbaLEBsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 20:48:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:29345 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaLEBsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 20:48:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,519,1413270000"; 
   d="scan'208";a="632994532"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "Zhang, Jun" <jun.zhang@intel.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>
Subject: RE: [PATCH v2] sched/fair: fix find_idlest_cpu return -1
Thread-Topic: [PATCH v2] sched/fair: fix find_idlest_cpu return -1
Thread-Index: AQHQD7wbCzODxs4zUUK8CCYucqaN15yAOvRg
Date: Fri, 5 Dec 2014 01:48:25 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01EEA8AF@SHSMSX101.ccr.corp.intel.com>
References: <1417693435-18247-1-git-send-email-jun.zhang@intel.com>
 <CAKfTPtC3cULoGtNz3X+0J0XNe9-aMCrZAocaqiaGKpY+ek1ZSQ@mail.gmail.com>
In-Reply-To: <CAKfTPtC3cULoGtNz3X+0J0XNe9-aMCrZAocaqiaGKpY+ek1ZSQ@mail.gmail.com>
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



> -----Original Message-----
> From: Vincent Guittot [mailto:vincent.guittot@linaro.org]
> Sent: Thursday, December 04, 2014 8:15 PM
> To: Zhang, Jun
> Cc: mingo@redhat.com; Peter Zijlstra; gregkh@linuxfoundation.org; Hillf
> Danton; linux-kernel; stable@vger.kernel.org; Liu, Chuansheng; Liu,
> Changcheng
> Subject: Re: [PATCH v2] sched/fair: fix find_idlest_cpu return -1
> 
> On 4 December 2014 at 12:43,  <jun.zhang@intel.com> wrote:
> > From: zhang jun <jun.zhang@intel.com>
> >
> > in function select_task_rq_fair, when find_idlest_cpu return -1 and sd->child
> == NULL
> > select_task_rq_fair return -1, system panic.
> 
> you forgot to add on which kernel version this patch applies.
> 
> We don't have such issue on 3.18-rc7 as find_idlest_cpu don't return
> -1. We only need a cleanup of the test against -1 for 3.18-rc
> 
Agreed, so Jun can make two patches:
The first one patch is in find_idlest_cpu() to not return -1 and based on stable-branch such as 3.14.x;
The second patch is one cleanup for new_cpu == -1 judgment against the 3.18-rc, since it is no possibility now;

Best Regards
Chuansheng

