Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaCKIW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:22:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61028 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbaCKIWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:22:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677577"
Message-ID: <531EC748.5010600@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 16:20:24 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, joe@perches.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 01/15] sched/prio: Add a macro named NICE_TO_RLIMIT in
 prio.h.
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com> <f475972d21de5738cf3302ab9c95c90fd4407815.1394513466.git.yangds.fnst@cn.fujitsu.com> <20140311081730.GA4298@osiris>
In-Reply-To: <20140311081730.GA4298@osiris>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 16:19:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 16:19:36,
	Serialize complete at 2014/03/11 16:19:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 04:17 PM, Heiko Carstens wrote:
> On Tue, Mar 11, 2014 at 12:59:16PM +0800, Dongsheng Yang wrote:
>> This patch add a macro named NICE_TO_RLIMIT in prio.h to
>> convert nice value [19,-20] to rlimit style value [1,40].
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   include/linux/sched/prio.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
>> index ac32258..8e78c47 100644
>> --- a/include/linux/sched/prio.h
>> +++ b/include/linux/sched/prio.h
>> @@ -41,4 +41,9 @@
>>   #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
>>   #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
>>   
>> +/*
>> + * Convert nice value [19,-20] to rlimit style value [1,40].
>> + */
>> +#define NICE_TO_RLIMIT(nice)	(MAX_NICE - nice + 1)
> Where is MAX_NICE defined? The s390 patch fails to compile.

MAX_NICE is defined in include/linux/sched/prio.h. It is applied in tip 
tree,
and not in mainline yet.
>
> Also you probably want at least extra braces around the 'nice' usage to
> avoid subtle side effects. (or make NICE_TO.. a function, whatever).

Yes, agree. Another question is that I am not sure when I need to use a 
macro
and when I should use a inline function.

Could you help to give me some sugguestion?

Thanx
>

