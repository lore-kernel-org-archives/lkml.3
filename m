Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbaE1WH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:07:28 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57608 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaE1WH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:07:27 -0400
MIME-Version: 1.0
X-Originating-IP: [2601:7:1680:338::529]
In-Reply-To: <1401237869.20587.12.camel@joe-AO725>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
	<1401236684-10579-12-git-send-email-dev@codyps.com>
	<1401237869.20587.12.camel@joe-AO725>
Date: Wed, 28 May 2014 17:07:25 -0500
Message-ID: <CAPoQQ-0Zdva0HiAB9yJ2CWCWtQNvYpfXW7BjNoc0CQ-m=6m3xA@mail.gmail.com>
Subject: Re: [PATCH 11/16] byteorder: provide a linux/byteorder.h with
 {be,le}_to_cpu() and cpu_to_{be,le}() macros
From: Cody P Schafer <dev@codyps.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 7:44 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2014-05-27 at 17:22 -0700, Cody P Schafer wrote:
>> Rather manually specifying the size of the integer to be converted, key
>> off of the type size. Reduces duplicate size info and the occurance of
>> certain types of bugs (using the wrong sized conversion).
> []
>> diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
> []
>> @@ -0,0 +1,34 @@
>> +#ifndef LINUX_BYTEORDER_H_
>> +#define LINUX_BYTEORDER_H_
>> +
>> +#include <asm/byteorder.h>
>> +
>> +#define be_to_cpu(v) \
>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint8_t) , v, \
>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint16_t), be16_to_cpu(v), \
>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint32_t), be32_to_cpu(v), \
>> +     __builtin_choose_expr(sizeof(v) == sizeof(uint64_t), be64_to_cpu(v), \
>> +             (void)0))))
>
> probably better to use BUILD_BUG instead of these 0 returns
>

They aren't 0 returns.

$ echo "int main(void) { int x = (void)0; return x; }" | gcc -x c -
<stdin>: In function ‘main’:
<stdin>:1:26: error: void value not ignored as it ought to be
