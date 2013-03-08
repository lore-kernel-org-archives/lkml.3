Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab3CHCd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:33:59 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46024 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759322Ab3CHCd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:33:58 -0500
Message-ID: <51394DF1.1030708@linux.vnet.ibm.com>
Date: Fri, 08 Mar 2013 10:33:21 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wakeup buddy
References: <5136EB06.2050905@linux.vnet.ibm.com> <1362676917.10972.23.camel@laptop>
In-Reply-To: <1362676917.10972.23.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030802-7014-0000-0000-000002B020AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 01:21 AM, Peter Zijlstra wrote:
> On Wed, 2013-03-06 at 15:06 +0800, Michael Wang wrote:
>> +static inline int wakeup_related(struct task_struct *p)
>> +{
>> +       if (wakeup_buddy(p, current)) {
>> +               /*
>> +                * Now check whether current still focus on his buddy.
>> +                */
>> +               if (wakeup_buddy(current, p))
>> +                       return 1;
>> +       }
>> +
>> +       return 0;
>> +}
> 
> Not commenting on the thing in general, but:
> 
> static inline bool wakeup_related(struct task_struct *p)
> {
> 	return wakeup_buddy(p, current) && wakeup_buddy(current, p);
> }
> 
> is far shorter and easier to read :-)

Right, I will correct it :)

Regards,
Michael Wang

> 

