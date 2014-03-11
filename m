Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaCKIqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:46:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49820 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaCKIqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:46:14 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9677769"
Message-ID: <531ECCD9.8050805@cn.fujitsu.com>
Date: Tue, 11 Mar 2014 16:44:09 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: linux-kernel@vger.kernel.org, joe@perches.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 01/15] sched/prio: Add a macro named NICE_TO_RLIMIT in
 prio.h.
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com> <f475972d21de5738cf3302ab9c95c90fd4407815.1394513466.git.yangds.fnst@cn.fujitsu.com> <20140311081730.GA4298@osiris> <531EC748.5010600@cn.fujitsu.com> <20140311083658.GB4298@osiris>
In-Reply-To: <20140311083658.GB4298@osiris>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 16:43:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 16:43:25,
	Serialize complete at 2014/03/11 16:43:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 04:36 PM, Heiko Carstens wrote:
> On Tue, Mar 11, 2014 at 04:20:24PM +0800, Dongsheng Yang wrote:
>> On 03/11/2014 04:17 PM, Heiko Carstens wrote:
>>> On Tue, Mar 11, 2014 at 12:59:16PM +0800, Dongsheng Yang wrote:
>>>> +#define NICE_TO_RLIMIT(nice)	(MAX_NICE - nice + 1)
>>> Where is MAX_NICE defined? The s390 patch fails to compile.
>> MAX_NICE is defined in include/linux/sched/prio.h. It is applied in
>> tip tree, and not in mainline yet.
> Ok.
>
>>> Also you probably want at least extra braces around the 'nice' usage to
>>> avoid subtle side effects. (or make NICE_TO.. a function, whatever).
>> Yes, agree. Another question is that I am not sure when I need to
>> use a macro and when I should use a inline function.
>>
>> Could you help to give me some sugguestion?
> You can ask three people and get five opinions ;)

Hehe :)
>
> However if your above define would have been an inline function it
> wouldn't suffer from possible subtle side effects and it would have
> sane type checking etc.  So usually functions should be preferred.

I prefer to inline function too, it makes me feel more safe.

I will update this patch with an inline function.

Thanx
>

