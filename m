Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423099Ab3FUGDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:03:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10537 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1161146Ab3FUGDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:03:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,910,1363104000"; 
   d="scan'208";a="7624635"
Message-ID: <51C3ED76.3040900@cn.fujitsu.com>
Date: Fri, 21 Jun 2013 14:06:46 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org,
        tj@kernel.org, trenn@suse.de, yinghai@kernel.org, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [Part1 PATCH v5 00/22] x86, ACPI, numa: Parse numa info earlier
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com> <51C3E276.8030804@zytor.com>
In-Reply-To: <51C3E276.8030804@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/21 14:02:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/21 14:02:42,
	Serialize complete at 2013/06/21 14:02:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 01:19 PM, H. Peter Anvin wrote:
> On 06/13/2013 06:02 AM, Tang Chen wrote:
>> From: Yinghai Lu<yinghai@kernel.org>
>>
>> No offence, just rebase and resend the patches from Yinghai to help
>> to push this functionality faster.
>> Also improve the comments in the patches' log.
>>
>
> So we need a new version of this which addresses the build problems and
> the feedback from Tejun... and it would be good to get that soon, or
> we'll be looking at 3.12.

Hi hpa,

The build problem has been fixed by Yinghai.

>
> Since the merge window is approaching quickly, is there a meaningful
> subset that is ready now?

I think memory hotplug needs at least part1 and part2 patches. But
local node pagetable (patch 21 and 22 in part1) will break memory
hot-remove path. My part3 intends to fix it, but it seems we need
local device pagetable to enable single device hotplug, but not just
local node pagetable.

So, my plan is

1. Implement arranging hotpluggable memory with SRAT first, within tj's
    comments, without local node pagetable.
    (The main work in part2. And of course, need some patches in part1.)
2. Do the local device pagetable work, not local node.
3. Improve memory hotplug to support local device pagetable.

I'll send a new version patch-set of step1, wishing we can catch up with
the merge window. And I think step2 and 3 should be done later.


Thanks. :)


