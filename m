Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab3FFAL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:11:26 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59177 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab3FFALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130605164804.8071867d28c1f20cad8d7d2a@linux-foundation.org>
References: <20130531161807.GA9536@www.outflux.net>
	<20130605164804.8071867d28c1f20cad8d7d2a@linux-foundation.org>
Date: Wed, 5 Jun 2013 17:11:23 -0700
X-Google-Sender-Auth: cgINe0tHOZvWCjQMXA0CffcIkoA
Message-ID: <CAGXu5jKj-z1d_ZVToa=+j6MKMPS522gnrOZS12pu+619eEUnQQ@mail.gmail.com>
Subject: Re: [PATCH] clean up scary strncpy(dst, src, strlen(src)) uses
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        devel@driverdev.osuosl.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 4:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 31 May 2013 09:18:07 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> Fix various weird constructions of strncpy(dst, src, strlen(src)). Length
>> limits should be about the space available in the destination, not
>> repurposed as a method to either always include or always exclude
>> a trailing NULL byte. Either the NULL should always be copied
>> (using strlcpy), or it should not be copied (using something like
>> memcpy). Readable code should not depend on the weird behavior of strncpy
>> when it hits the length limit. Better to avoid the anti-pattern entirely.
>>
>> ...
>>
>> --- a/Documentation/accounting/getdelays.c
>> +++ b/Documentation/accounting/getdelays.c
>> @@ -23,6 +23,7 @@
>>  #include <sys/socket.h>
>>  #include <sys/wait.h>
>>  #include <signal.h>
>> +#include <bsd/string.h>
>>
>>  #include <linux/genetlink.h>
>>  #include <linux/taskstats.h>
>> @@ -299,7 +300,7 @@ int main(int argc, char *argv[])
>>                       break;
>>               case 'C':
>>                       containerset = 1;
>> -                     strncpy(containerpath, optarg, strlen(optarg) + 1);
>> +                     strlcpy(containerpath, optarg, sizeof(containerpath));
>>                       break;
>>               case 'w':
>>                       logfile = strdup(optarg);
>
> Documentation/accounting/getdelays.c:26:24: fatal error: bsd/string.h: No such file or directory
>
> I'll revert this part.

Ah, hrm. Well, in that case, it should use strdup, as logfile does
already. Do you want me to send a patch for that?

-Kees

--
Kees Cook
Chrome OS Security
