Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbaEMJc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:32:56 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:40468 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394AbaEMJcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAAG0J9-ieBNfyRa6kf22TNd_3mg57GYuGHagQ-pPLY41iM3Zyg@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
	<1399971749-4004-1-git-send-email-lftan@altera.com>
	<CAAG0J9-ieBNfyRa6kf22TNd_3mg57GYuGHagQ-pPLY41iM3Zyg@mail.gmail.com>
Date: Tue, 13 May 2014 17:32:52 +0800
X-Google-Sender-Auth: ANISpoCU41T_p36pzbYiY99_XRM
Message-ID: <CAFiDJ5-ez-Brqr8q3=XbODzLtFFU=e4qS12bCPo=5FE1JTNr+A@mail.gmail.com>
Subject: Re: [PATCH 01/25] asm-generic: Change time_t and clock_t to 64 bit
From: Ley Foon Tan <lftan@altera.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 5:15 PM, James Hogan <james.hogan@imgtec.com> wrote:
> Hi,
>
> On 13 May 2014 10:02, Ley Foon Tan <lftan@altera.com> wrote:
>> Use 64 bit time_t and clock_t as default. 32 bit users can provide
>> an override to define these as "long" if needed.
>>
>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>> ---
>>  include/uapi/asm-generic/posix_types.h | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/asm-generic/posix_types.h b/include/uapi/asm-generic/posix_types.h
>> index fe74fcc..3f0e613 100644
>> --- a/include/uapi/asm-generic/posix_types.h
>> +++ b/include/uapi/asm-generic/posix_types.h
>> @@ -81,12 +81,22 @@ typedef struct {
>>  #endif
>>
>>  /*
>> + * Use 64 bit time_t and clock_t as default. 32 bit users can provide an override to
>> + * define these as "long" if needed.
>> + */
>> +#ifndef __kernel_time_t
>> +typedef long long      __kernel_time_t;
>> +#endif
>> +
>> +#ifndef __kernel_clock_t
>> +typedef long long      __kernel_clock_t;
>> +#endif
>
> I think having this as the first patch in the series will break
> bisection for existing 32-bit arches. This needs to be done in such a
> way that at no intermediate commit are __kernel_time_t or
> __kernel_clock_t the wrong size for existing arches, e.g. by having a
> first patch which makes the typedefs conditional but leaves them as
> __kernel_long_t, and a final patch that changes the default after all
> the arches have got their overrides in place.

Your suggestion is something as below?

First patch:
#ifndef __kernel_time_t
typedef __kernel_long_t      __kernel_time_t;
#endif

Last patch:
#ifndef __kernel_time_t
typedef long long      __kernel_time_t;
#endif

Ley Foon
