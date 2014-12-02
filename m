Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaLBIg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:36:57 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:49973 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751288AbaLBIg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:36:56 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44338314"
Message-ID: <547D7B05.6080403@cn.fujitsu.com>
Date: Tue, 2 Dec 2014 16:40:37 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com> <20141126024032.GA13246@redhat.com> <20141126225745.GA30346@redhat.com> <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com> <20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org> <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com> <547b8a45.6e608c0a.20f9.1002@mx.google.com> <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com> <547bbe36.48548c0a.105c.779c@mx.google.com> <20141201191431.GA17385@linux.vnet.ibm.com>
In-Reply-To: <20141201191431.GA17385@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 03:14 AM, Paul E. McKenney wrote:
> On Sun, Nov 30, 2014 at 11:02:43PM -0200, Dâniel Fraga wrote:
>> On Sun, 30 Nov 2014 16:21:19 -0800
>> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>>> Maybe you'll have to turn off RCU_CPU_STALL_VERBOSE first.
>>>
>>> Although I think you should be able to just edit the .config file,
>>> delete the like that says
>>>
>>>     CONFIG_TREE_PREEMPT_RCU=y
>>>
>>> and then just do a "make oldconfig", and then verify that
>>> TREE_PREEMPT_RCU hasn't been re-enabled by some dependency. But it
>>> shouldn't have, and that "make oldconfig" should get rid of anything
>>> that depends on TREE_PREEMPT_RCU.
>> 	
>> 	Ok, I did exactly that, but CONFIG_TREE_PREEMPT_RCU is
>> re-enabled. I talked with Pranith Kumar and he suggested I could just
>> disable preemption (No Forced Preemption (Server)) and that's the only
>> way to disable CONFIG_TREE_PREEMPT_RCU.
> 
> If it would help to have !CONFIG_TREE_PREEMPT_RCU with CONFIG_PREEMPT=y,

It is needed at lest for testing.

CONFIG_TREE_PREEMPT_RCU=y with CONFIG_PREEMPT=n is needed for testing too.

Please enable them (or enable them under CONFIG_RCU_TRACE=y)

> please let me know and I will create a patch that forces this.
> (Not mainline material, but if it helps with debug...)
> 
> 							Thanx, Paul
> 
>> 	Now I'll try to make the system freeze, then I'll send
>> you the Call trace.
>>
>> 	Thanks.
>>
>> -- 
>> Linux 3.17.0: Shuffling Zombie Juror
>> http://www.youtube.com/DanielFragaBR
>> http://exchangewar.info
>> Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

