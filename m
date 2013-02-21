Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3BUEw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 23:52:26 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:56264 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3BUEwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:52:23 -0500
Message-ID: <5125A7F8.9060603@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 12:52:08 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
References: <51079178.3070002@linux.vnet.ibm.com> <510791B2.6090506@linux.vnet.ibm.com> <1361366462.10155.24.camel@laptop>
In-Reply-To: <1361366462.10155.24.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022104-8256-0000-0000-0000064CB984
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 09:21 PM, Peter Zijlstra wrote:
> On Tue, 2013-01-29 at 17:09 +0800, Michael Wang wrote:
>> +       for_each_possible_cpu(cpu) {
>> +               sbm = &per_cpu(sbm_array, cpu);
>> +               node = cpu_to_node(cpu);
>> +               size = sizeof(struct sched_domain *) * sbm_max_level;
>> +
>> +               for (type = 0; type < SBM_MAX_TYPE; type++) {
>> +                       sbm->sd[type] = kmalloc_node(size, GFP_KERNEL,
>> node);
>> +                       WARN_ON(!sbm->sd[type]);
>> +                       if (!sbm->sd[type])
>> +                               goto failed;
>> +               }
>> +       }
> 
> You can't readily use kmalloc_node() here, cpu_to_node() might return an
> invalid node for offline cpus here.
> 
> Also see: 2ea45800d8e1c3c51c45a233d6bd6289a297a386

Hi, Peter

Thanks for your reply, I've not noticed this point, Mike had suggested
to do allocation in notifier when cpu is online, I will try to use that
idea in the formal patch set.

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

