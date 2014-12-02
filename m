Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbaLBKXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:23:33 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:56033 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLBKXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:23:31 -0500
Message-ID: <547D9308.8080403@huawei.com>
Date: Tue, 2 Dec 2014 18:23:04 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <tixy@linaro.org>, <linux@arm.linux.org.uk>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 1/7] ARM: probes: move all probe code to dedicate
 directory
References: <1417423513-47161-1-git-send-email-wangnan0@huawei.com> <1417423695-47521-1-git-send-email-wangnan0@huawei.com> <547D471B.2070908@hitachi.com>
In-Reply-To: <547D471B.2070908@hitachi.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.547D9322.0072,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 0572fd1f03bad724ccf0bdfe081d47d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/2 12:59, Masami Hiramatsu wrote:
> (2014/12/01 17:48), Wang Nan wrote:
>> In discussion on LKML (https://lkml.org/lkml/2014/11/28/158), Russell
>> King suggest to move all probe related code to arch/arm/probes. This
>> patch do the work. Due to dependency on 'arch/arm/kernel/patch.h', this
>> patch also move patch.h to 'arch/arm/include/asm/patch.h', and related
>> '#include' directive are also midified to '#include <asm/patch.h>'.
> 
> Moving is good to me, but renaming files are also required I think.
> 
>> Signed-off-by: Wang Nan <wangnan0@huawei.com>
>> ---
>>  arch/arm/Makefile                                |  1 +
>>  arch/arm/{kernel => include/asm}/patch.h         |  0
>>  arch/arm/kernel/Makefile                         | 16 ++--------------
>>  arch/arm/kernel/jump_label.c                     |  2 +-
>>  arch/arm/kernel/patch.c                          |  3 +--
>>  arch/arm/probes/Makefile                         | 15 +++++++++++++++
>>  arch/arm/{kernel => probes}/kprobes-arm.c        |  0
>>  arch/arm/{kernel => probes}/kprobes-common.c     |  0
>>  arch/arm/{kernel => probes}/kprobes-test-arm.c   |  0
>>  arch/arm/{kernel => probes}/kprobes-test-thumb.c |  0
>>  arch/arm/{kernel => probes}/kprobes-test.c       |  0
>>  arch/arm/{kernel => probes}/kprobes-test.h       |  0
>>  arch/arm/{kernel => probes}/kprobes-thumb.c      |  0
>>  arch/arm/{kernel => probes}/kprobes.c            |  2 +-
>>  arch/arm/{kernel => probes}/kprobes.h            |  0
>>  arch/arm/{kernel => probes}/probes-arm.c         |  0
>>  arch/arm/{kernel => probes}/probes-arm.h         |  0
>>  arch/arm/{kernel => probes}/probes-thumb.c       |  0
>>  arch/arm/{kernel => probes}/probes-thumb.h       |  0
>>  arch/arm/{kernel => probes}/probes.c             |  0
>>  arch/arm/{kernel => probes}/probes.h             |  0
>>  arch/arm/{kernel => probes}/uprobes-arm.c        |  0
>>  arch/arm/{kernel => probes}/uprobes.c            |  0
>>  arch/arm/{kernel => probes}/uprobes.h            |  0
> 
> As I did on x86, these would be better renamed as expressing what they do.
> I guess most of the files may have emulate-*.c or decode-*.c :)
> 
> Thank you,
> 

OK. I posted another patch in this thread. The directory tree is as follow:

arch/arm/probes/
|-- Makefile
|-- decode-arm.c
|-- decode-arm.h
|-- decode-thumb.c
|-- decode-thumb.h
|-- decode.c
|-- decode.h
|-- kprobes
|   |-- actions-arm.c
|   |-- actions-common.c
|   |-- actions-thumb.c
|   |-- kprobes.c
|   |-- kprobes.h
|   |-- test-arm.c
|   |-- test-core.c
|   |-- test-core.h
|   `-- test-thumb.c
`-- uprobes
    |-- actions-arm.c
    |-- uprobes.c
    `-- uprobes.h

2 directories, 19 files

What do you think?

> 
> 


