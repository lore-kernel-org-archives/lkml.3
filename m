Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3BVGGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:06:30 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45222 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3BVGG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:06:28 -0500
Message-ID: <51270AD9.9020908@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 14:06:17 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com> <1361509697.5817.65.camel@marge.simpson.net>
In-Reply-To: <1361509697.5817.65.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022206-5816-0000-0000-000006C8C818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 01:08 PM, Mike Galbraith wrote:
> On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
> 
>> According to the testing result, I could not agree this purpose of
>> wake_affine() benefit us, but I'm sure that wake_affine() is a terrible
>> performance killer when system is busy.
> 
> (hm, result is singular.. pgbench in 1:N mode only?)

I'm not sure about how pgbench implemented, all I know is it will create
several instance and access the database, I suppose no different from
several threads access database (1 server and N clients?).

There are improvement since when system busy, wake_affine() will be skipped.

And in old world, when system is busy, wake_affine() will only be
skipped if prev_cpu and curr_cpu belong to different nodes.

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

