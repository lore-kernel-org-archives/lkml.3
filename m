Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaBJC4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:56:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32043 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbaBJC4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:56:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,815,1384272000"; 
   d="scan'208";a="9494371"
Message-ID: <52F83FE2.90004@cn.fujitsu.com>
Date: Mon, 10 Feb 2014 10:56:34 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, raistlin@linux.it,
        juri.lelli@gmail.com, clark.williams@gmail.com, mingo@redhat.com,
        rostedt@goodmis.org
Subject: Re: [PATCH 1/3] sched: Move the priority specific bits into a new
 header file.
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com> <f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com> <87fvo75pci.fsf@sejong.aot.lge.com>
In-Reply-To: <87fvo75pci.fsf@sejong.aot.lge.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 10:54:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/10 10:54:23,
	Serialize complete at 2014/02/10 10:54:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Namhyung,

On 01/29/2014 01:28 PM, Namhyung Kim wrote:
> Hi Dongsheng,
>
> On Mon, 27 Jan 2014 17:15:37 -0500, Dongsheng Yang wrote:
>> Some bits about priority are defined in linux/sched/rt.h, but
>> some of them are not only for rt scheduler, such as MAX_PRIO.
>>
>> This patch move them all into a new header file, linux/sched/prio.h.
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   include/linux/sched.h      |  4 ++++
>>   include/linux/sched/prio.h | 23 +++++++++++++++++++++++
>>   include/linux/sched/rt.h   | 21 +++------------------
>>   3 files changed, 30 insertions(+), 18 deletions(-)
>>   create mode 100644 include/linux/sched/prio.h
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 68a0e84..ba1b732 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -3,6 +3,10 @@
>>   
>>   #include <uapi/linux/sched.h>
>>   
>> +#ifndef _SCHED_PRIO_H
>> +#include <linux/sched/prio.h>
>> +#endif /* #ifndef _SCHED_PRIO_H */
> It seems you don't need to use #ifndef-#endif pair to include a header
> file?

Sorry for the late reply, coming back from vacation for Chinese Spring 
Festival.

The reason I use #ifndef-#endif here is that there are lots of files,
  such as kernel/sched/sched.h, are including <linux/sched.h> and
<linux/sched/rt.h>. And both of them are including prio.h.

I am not sure should we avoid reincluding a file and how.

Could you help to give me some suggestion of it. Thanx :)

> Thanks,
> Namhyung
>

