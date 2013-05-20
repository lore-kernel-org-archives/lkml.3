Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3ETMv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:51:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3ETMv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:51:56 -0400
Message-ID: <519A1C64.3020807@dawncrow.de>
Date: Mon, 20 May 2013 14:51:48 +0200
From: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCHv4] arm: Preserve the user r/w register TPIDRURW on context
 switch and fork
References: <518AA19B.2020209@dawncrow.de> <51979801.7010903@dawncrow.de> <519A030D.1030809@arm.com>
In-Reply-To: <519A030D.1030809@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:EWc7eXIPXNGkbe0WpQ8dOnxZUmRJPXr4NAuCEB0UTzM
 ziLjFv418mLreRPo/v/GZRln3BpC+MACbcw0jmV+uv+kSobbUv
 R1zuufRHUB8ATKljtD163BAR/izrY43zqjghdKSCXFEW6UAy4a
 KVmRjMxzdTnW71rZfkDEMWY1cm+L9Jvrq37ROZdqf1ztvR2sHq
 jtZtHlWldavMuiISaaKBuS2ppvNazPsz6g/oRmPSW8wygLX4i+
 RxaKd20btDWt7hc72xllo/RkXltmgIPKLE19ock91R3vV7OtZF
 kHyYJu85eLm5tzSq0MuZZ8oy7zoqDh7SpCdiUViv9fIYIo+D7B
 XJdil5dL/May9FwlRlUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.05.2013 13:03, schrieb Jonathan Austin:
> Hi André
> 
> On 18/05/13 16:02, André Hentschel wrote:
>> Am 08.05.2013 21:03, schrieb André Hentschel:
>>> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
>>>
> 
> This is strangely formatted for me too, and I use a different client from Will so I'm not sure that the problem is just at our end...
> 
> (Also see that the list archive has weird formatting:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/167325.html )
> 
> Your first couple of patches didn't come out strangely formatted, so I'm not really sure what's going on.

I'll retry it with plain Text or something. AFAIK git should understand this =UTF= style, though.

>>> Since commit 6a1c53124aa1 the user writeable TLS register was zeroed to
>>> prevent it from being used as a covert channel between two tasks.
>>>
>>> There are more and more applications coming to WinRT, Wine could support them,
>>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
>>>
>>> This patch preserves that register per thread instead of clearing it.
>>> Unlike the TPIDRURO, which is already switched, the TPIDRURW
>>> can be updated from userspace so needs careful treatment in the case that we
>>> modify TPIDRURW and call fork(). To avoid this we must always read
>>> TPIDRURW in copy_thread.
>>>
>>> Signed-off-by: André Hentschel <nerv@dawncrow.de>
>>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>>> Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
>>>
>>
>> Hi,
>> I'm not yet very familiar with the development process here,
>> am i getting no feedback on v4 because of the mergewindow being closed?
>> Or is there another reason? Sry for being impatient.
>>
> 
> This is a feature, not a fix, so most likely it'll be included at the next merge window. For that to happen it should be in Russell's tree around the middle of this cycle.
> 
> Can you please rebase on 3.10-rc2 (when it happens) and post one more version? After that, assuming nobody else has any final comments, you could put it in to Russell's patch system...
> 
> Just as a hint - one thing you might have done to increase the chances of getting comments to clarify what's different between v3 and v4 - as a way to make life easier for reviewers you can highlight the differences between versions after the "---" (where you currently have the description of why there are so many S-o-Bs).

I'll do, thank you very much for the reply and the clarification.

