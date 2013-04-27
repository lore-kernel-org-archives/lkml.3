Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3D0J3v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 05:29:51 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45282 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab3D0J3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 05:29:49 -0400
Message-ID: <517B9A4D.1020502@gmail.com>
Date: Sat, 27 Apr 2013 17:28:45 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: Chen Gang <gang.chen@asianux.com>, Michael Neuling <mikey@neuling.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] PowerPC: kernel: compiling issue, make additional
 room in exception vector area
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <20130425062539.GA421@iris.ozlabs.ibm.com> <517918AB.4020508@asianux.com> <30269.1366931768@ale.ozlabs.ibm.com> <5179D302.9060203@asianux.com> <5179D5D8.8080102@asianux.com> <5179DA23.8000407@asianux.com> <5179E056.2000709@linux.vnet.ibm.com> <5179E11F.8010007@asianux.com> <5179EFB6.3090602@linux.vnet.ibm.com> <5179F39C.5020408@asianux.com> <5179F7B8.5010701@asianux.com> <5179FA8E.9090501@linux.vnet.ibm.com>
In-Reply-To: <5179FA8E.9090501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月26日 11:54, Mike Qiu wrote:
> 于 2013/4/26 11:42, Chen Gang 写道:
>> On 2013年04月26日 11:25, Chen Gang wrote:
>>> On 2013年04月26日 11:08, Mike Qiu wrote:
>>>> 于 2013/4/26 10:06, Chen Gang 写道:
>>>>> On 2013年04月26日 10:03, Mike Qiu wrote:
>>>>>> �� 2013/4/26 9:36, Chen Gang д��:
>>>>>>>> On 2013��04��26�� 09:18, Chen Gang wrote:
>>>>>>>>>> On 2013��04��26�� 09:06, Chen Gang wrote:
>>>>>>>>>>>>>> CFAR is the Come From Register.  It saves the location of the
>>>>>>>>>>>>>> last
>>>>>>>>>>>>>>>> branch and is hence overwritten by any branch.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>> Do we process it just like others done (e.g. 0x300, 0xe00,
>>>>>>>>>>>> 0xe20 ...) ?
>>>>>>>>>>>>      . = 0x900
>>>>>>>>>>>>      .globl decrementer_pSeries
>>>>>>>>>>>> decrementer_pSeries:
>>>>>>>>>>>>        HMT_MEDIUM_PPR_DISCARD
>>>>>>>>>>>>      SET_SCRATCH0(r13)
>>>>>>>>>>>>      b decrementer_pSeries_0
>>>>>>>>>>>>
>>>>>>>>>>>>      ...
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>> Oh, it seems EXCEPTION_PROLOG_1 will save the regesters which
>>>>>>>> related
>>>>>>>> with CFAR, so I think need move EXCEPTION_PROLOG_1 to near 0x900.
>>>>>> I will try your diff V2, to see if the machine can boot up
>>>>> OK, thanks. (hope it can work)
>>>> It seems that the machine can be bootup in powernv mode, but I'm not
>>>> sure if my machine call that module.
>>>>
>>>> At lease my machine can boot up
>> Please reference commit number: 1707dd161349e6c54170c88d94fed012e3d224e3
>> (1707dd1 powerpc: Save CFAR before branching in interrupt entry paths)
>>
>> What our diff v2 has done is just the fix for our patch v2 (just like
>> the commit 1707dd1 has done).
>>
>> Please check, thanks.
>>
>> :-)
> I will check this evening or tomorrow, I have something else to do this
> afteroon.

I think the diff v2 is correct, but is not the best one for this issue.

I prefer the Paul's patch for this issue which has better performance

:-)


Thanks.

-- 
Chen Gang

Flying Transformer
