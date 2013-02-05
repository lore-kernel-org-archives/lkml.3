Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3BEQeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:34:50 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:61287 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3BEQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:34:49 -0500
MIME-Version: 1.0
Date: Tue, 5 Feb 2013 11:34:48 -0500
Message-ID: <CAO-9seCKXmLYxnbAxj_owbUqwn07HeJHnNS_gyui7H=auQpnxQ@mail.gmail.com>
Subject: Re: Opteron 6276 Corrected ECC errors
From: Michael Madore <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jan 30, 2013 at 11:29:47AM -0500, Michael Madore wrote:
>> Supermicro H8QGi-F server board (AMD SR5690/SR5670/SP5100 Chipset)
>> 4 X AMD Opteron 6276 processors
>> 32 X 8GB (256GB) DDR3-1600 ECC Registered memory
>> Debian with kernel 3.2.35-2
>>
>> We have received the following two hardware errors:
>>
>> 9/10/12
>>
>> [591006.120039] [Hardware Error]: CPU:58
>> MC2_STATUS[-|CE|MiscV|-|-|-|-|CECC]: 0x9842c000000c0176
>> [591006.120048] [Hardware Error]: Combined Unit Error: VB Data/ECC error.
>> [591006.120052] [Hardware Error]: cache level: L2, tx: DATA, mem-tx: EV
>>
>> 1/21/12
>>
>> [549004.336097] [Hardware Error]: CPU:40
>> MC4_STATUS[-|CE|MiscV|-|AddrV|-|-|CECC]: 0x9c3444e0001f010b
>> [549004.336111] [Hardware Error]:       MC4_ADDR: 0x000000000000e480
>> [549004.336117] [Hardware Error]: Northbridge Error (node 5): ECC
>> Error in the Probe Filter directory.
>> [549004.336125] [Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: GEN
>>
>> If I understand correctly, both of these errors represent single bit
>> corrected errors in the CPU cache.
>
> Internal CPU structures, victim buffer the first and the second in the
> probe filter which is part of L3.
>
>> On both occasions the system continued to function normally after the
>> error was reported.
>
> As expected; both are single-bit ECC errors which were corrected and
> system state wasn't influenced.
>
>> Is receiving two such errors (on different CPUs) over such a time span
>> cause for concern?
>
> Not really. I'd say, only if the error rate starts increasing over time
> and the error types keep repeating.
>
>> The end user is concerned there is a serious hardware problem. I'm
>> reluctant to start replacing CPUs, however, without seeing a repeated
>> pattern of errors.
>
> Yes, no need to replace, simply watch the error rates. Maybe check the
> temperature of the CPUs, possibly improve cooling are some of the things
> that come to mind.

Hi Boris,

Thank you for the information.  The system has just received a third error:

[573603.432036] [Hardware Error]: CPU:32
MC4_STATUS[-|CE|MiscV|-|AddrV|-|Poison|CECC]: 0x9c43ccb0011c017b
[573603.432045] [Hardware Error]:  MC4_ADDR: 0x0000002782598940
[573603.432048] [Hardware Error]: Northbridge Error (node 4): L3 ECC
data cache error.
[573603.432054] [Hardware Error]: cache level: L3/GEN, tx: GEN, mem-tx: EV

This is on a different node than the previous two errors.  And each
node has it's own L3, correct?  Would you still advocate watching and
waiting?

Thanks,

Mike
