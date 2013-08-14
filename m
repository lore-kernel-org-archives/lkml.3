Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab3HNOI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:08:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51763 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab3HNOIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:08:25 -0400
Message-ID: <520B8F37.4040609@dawncrow.de>
Date: Wed, 14 Aug 2013 16:07:51 +0200
From: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: arm: Only load TLS values when needed
References: <51E42E11.1010903@dawncrow.de> <51E5836B.1010904@arm.com> <51E59E8F.1060501@dawncrow.de> <51E67B98.9040101@arm.com> <51E6F532.1030004@dawncrow.de>
In-Reply-To: <51E6F532.1030004@dawncrow.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:bTsvxsW3PhiQJUz0+4aWiWu9dCCmU8RELXxxJ20Q0eC
 RSXE4+41UOwMeNp7axzn8zjBXZMALSPZ0WdQ+Ug82edUUfoqnA
 0K38hk2U+Aw36r2kqYhVHx6RWrEeDtCSz2xAKJOKrEJhcVwF7w
 FfdHZqZATZcOpUii8u6pYmWUPAg8rgzAZs1oSvoQE/yOMq3rqq
 omayJX2o3nzWmV4LMj2qh+yvbRUmxCdChasEBalz9PgcpPnLKH
 j7b+qpQr+WDvaE7cx11kkd4vGiZ4/qW1abro/TcL2aWgEdsv50
 02tkZuzDgbXiwRkYtcwEvJnsGn3b27jbsPdbQiO+TwePGnUBPq
 MWRvGop0d6Yus47hKD0g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,
Any updates on this?

Am 17.07.2013 21:49, schrieb André Hentschel:
> Am 17.07.2013 13:10, schrieb Jonathan Austin:
>> Hi André,

>> Do you have access to anything v6-NOT-k-ish? If not I can try and test this on something appropriate. How does your test-case access tpidrurw? If it uses inline asm then it won't work on v6-not-k, as those instructions aren't defined...
> 
> I don't, so it'd be nice if you could do that. I could imagine you have a good choice of devices at ARM :)
> 
> In my crappy test application i do it similar to Wine:
> https://github.com/AndreRH/tpidrurw-test/blob/master/main.c#L29
> 
> but Wine code won't work out of the box on v6:
> http://source.winehq.org/git/wine.git/blob/HEAD:/dlls/ntdll/signal_arm.c#l851
> 

>>> I'm not sure how this could make things worse on v6k, could you
>>> elaborate please? Besides of the ldr and str being too close to each
>>> other
>>
>> Yea, that's the only issue, and in the !CONFIG_CPU_USE_DOMAINS case things are slightly worse than they were before
>>
>>> i thought this patch is a good idea, because it removes two ldr
>>> which are always executed. (Continuing below...)
>>
>> Indeed, as long as it doesn't cause pipeline stalls then that's a gain for some cases :)
>>
>> [...]
>>>> Now we've only got one instruction between the store and the load
>>>> and risk stalling the pipeline...
>>>>
>>>> Dave M cautiously says "The ancient advice was that one instruction
>>>> was enough" but this is very core dependent... I wonder if anyone
>>>> has a good idea about whether this is an issue here...?
>>>
>>> We could use a ldrd at the top, that'd be nearly what we have right
>>> now, don't we?
>>
>> Yea, that'd be good - as far as I can see from an 1136 TRM, the ldrd *may* be two cycles (depending on alignment of the words) but the ldr and ldrne will always be two cycles. Ahhh, the joys of modifying the fast path ;)

