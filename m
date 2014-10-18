Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaJRPkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 11:40:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaJRPko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 11:40:44 -0400
Message-ID: <544289F8.3020704@nod.at>
Date: Sat, 18 Oct 2014 17:40:40 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Manfred Schlaegl <manfred.schlaegl@gmx.at>, Jeff Dike <jdike@addtoit.com>
CC: Daniel Walter <dwalter@google.com>, Randy Dunlap <rdunlap@infradead.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Remove unused bp stack-frame pointer
References: <544277C5.9030302@gmx.at> <54427C48.9050608@nod.at> <54428348.2050209@gmx.at> <54428500.6020304@nod.at> <5442862A.4090408@gmx.at>
In-Reply-To: <5442862A.4090408@gmx.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.10.2014 um 17:24 schrieb Manfred Schlaegl:
> On 2014-10-18 17:19, Richard Weinberger wrote:
>> Am 18.10.2014 um 17:12 schrieb Manfred Schlaegl:
>>> On 2014-10-18 16:42, Richard Weinberger wrote:
>>>> Am 18.10.2014 um 16:23 schrieb Manfred Schlaegl:
>>>>> The pointer to bp stack-frame is no longer used. Removed it.
>>>>
>>>> Good catch!
>>> Thank you.
>>>
>>>>
>>>>> This also removes a corresponding compiler-warning.
>>>>
>>>> Which warning exactly?
>>>
>>> On "normal" (defconfig) builds the warning does not show up because CONFIG_FRAME_POINTER is set.
>>> I've found the unused bp because CONFIG_FRAME_POINTER was not set in my configuration.
>>>
>>>   CC      arch/um/kernel/sysrq.o
>>> arch/um/kernel/sysrq.c: In function ‘show_stack’:
>>> arch/um/kernel/sysrq.c:32:29: warning: unused variable ‘bp’ [-Wunused-variable]
>>
>> Looks like my gcc need's an upgrade. :D
>>
>> Thanks,
>> //richard
>>
> 
> I'm using gcc version 4.7.2 (Debian 4.7.2-5). -> not THAT new ;-)

With a cup of coffee applied I managed it to read your mail correctly.
The warning triggers only with CONFIG_FRAME_POINTER=n. Now it makes sense.

Thanks,
//richard
