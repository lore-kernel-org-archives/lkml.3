Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaENB5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 21:57:55 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:48430 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaENB5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 21:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <53727DE8.7000105@gmx.de>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<1399971966-4598-1-git-send-email-lftan@altera.com>
	<53727DE8.7000105@gmx.de>
Date: Wed, 14 May 2014 09:57:50 +0800
X-Google-Sender-Auth: 8j_3Gsb8A0ZNAtm9btS_JxRJMdE
Message-ID: <CAFiDJ5_ziSF3ectbkFQp9L5FExwyGQBVsesP3JYAypURhNsKrQ@mail.gmail.com>
Subject: Re: [PATCH 17/25] parisc: Add 32 bit time_t and clock_t
From: Ley Foon Tan <lftan@altera.com>
To: Helge Deller <deller@gmx.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 4:17 AM, Helge Deller <deller@gmx.de> wrote:
> Hi Ley,
>
> On 05/13/2014 11:06 AM, Ley Foon Tan wrote:
>> Override time_t and clock_t in include/uapi/asm-generic.
>>
>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>> ---
>>  arch/parisc/include/uapi/asm/posix_types.h | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/parisc/include/uapi/asm/posix_types.h b/arch/parisc/include/uapi/asm/posix_types.h
>> index b934425..21fcf1c 100644
>> --- a/arch/parisc/include/uapi/asm/posix_types.h
>> +++ b/arch/parisc/include/uapi/asm/posix_types.h
>> @@ -19,6 +19,14 @@ typedef int                        __kernel_suseconds_t;
>>  typedef long long            __kernel_off64_t;
>>  typedef unsigned long long   __kernel_ino64_t;
>>
>> +#ifndef CONFIG_64BIT
>
> We can't use CONFIG_64BIT for a userspace header file. Please use
> #if !defined(__LP64__)
> instead.
> But even then I'm not sure if it's all correct...
Okay, will change to this. Maybe can try compile and boot with this change.

Thanks.
Regards
Ley Foon
