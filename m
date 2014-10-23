Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaJWI5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:57:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47882 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaJWI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:57:41 -0400
Message-ID: <5448C2FE.8020507@hitachi.com>
Date: Thu, 23 Oct 2014 17:57:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi
Subject: Re: Re: [PATCH v3 5/5] perf/sdt: Add support to perf record to
 trace SDT events
References: <20141010104402.15506.73285.stgit@hemant-fedora> <20141010105914.15506.84827.stgit@hemant-fedora> <54475292.20409@hitachi.com> <544768C6.6090105@linux.vnet.ibm.com> <54477BE6.2060006@hitachi.com> <20141023055422.GA27939@linux.vnet.ibm.com> <5448A141.7050601@hitachi.com> <87oat3dwn2.fsf@sejong.aot.lge.com>
In-Reply-To: <87oat3dwn2.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/23 17:21), Namhyung Kim wrote:
> Hi Masami,
> 
> On Thu, 23 Oct 2014 15:33:37 +0900, Masami Hiramatsu wrote:
>> (2014/10/23 14:54), Srikar Dronamraju wrote:
>>> I am somehow not able to figure out how perf probe comes into the
>>> current workflow.
>>>
>>> I think the current design was
>>> 1. perf sdt-cache --add <file> (only once per file)
>>> 2. perf record -e <sdt-event>
>>>
>>> So what is the additional thing that perf probe does or Is it going to
>>> replace any of the above steps?
>>
>> 3. perf probe -a <sdt-event>
>>
>> And this will be done subsequently in this series (without user interface part).
>> However, current implementation of 2. will do the following steps
>>
>> s1. get sdt event data from sdt-cache
>> s2. set up sdt events with suppressing messages
>> s3. do recording events
>> (s4. and hiding existing sdt events from perf-probe --list)
>> s5. remove sdt events
>>
>> So, what I proposed were ;
>> - to implement s2., we can introduce --quiet(-q) option and use it
>>   instead of ->sdt flag checking
>> - removing s4. and s5.
>> - and add verification of existing sdt events at s2. if needed.
> 
> I'm okay with removing the s4 but not sure about the s5.  In that case,
> we might have many dynamic events in a system without noticing to users.

Indeed, okey, so let's keep s5 then :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


