Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbaFZLpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:45:33 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:47011 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbaFZLpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <1772413.506pXYt1XL@sifl>
References: <1402502130-26400-1-git-send-email-gidisrael@gmail.com>
 <3604441.fZpjWNppGq@sifl> <CAMuHMdVJ7zv0qqhZNMNXihm4Kqv9WA9yyMe3F9ptUZyDjvEnTg@mail.gmail.com>
 <1772413.506pXYt1XL@sifl>
From: "Gideon D'souza" <gidisrael@gmail.com>
Date: Thu, 26 Jun 2014 17:15:11 +0530
Message-ID: <CAPNrq4wa2+7-KD5hkiH_bEehy6CMjKPgQdxKVrLzWZmW4Qa8fg@mail.gmail.com>
Subject: Re: [PATCH 1/1] security: Used macros from compiler.h instead of __attribute__((...))
To: Paul Moore <paul@paul-moore.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, sds@tycho.nsa.gov,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Paul and Geert,

Sorry I didn't response quick enough, I was out of town on a trip.
Just got back.

Didn't even think of LLVM honestly but that is an excellent point and
I'll try compiling with it.

Paul, thanks for applying my patch.

Regards,
Gideon

On Thu, Jun 19, 2014 at 2:28 AM, Paul Moore <paul@paul-moore.com> wrote:
> On Wednesday, June 18, 2014 10:08:13 PM Geert Uytterhoeven wrote:
>> On Wed, Jun 18, 2014 at 8:50 PM, Paul Moore <paul@paul-moore.com> wrote:
>> > On Wednesday, June 11, 2014 09:25:30 PM Gideon Israel Dsouza wrote:
>> >> To increase compiler portability there is <linux/compiler.h> which
>> >> provides convenience macros for various gcc constructs.  Eg: __packed
>> >> for __attribute__((packed)).
>> >>
>> >> This patch is part of a large task I've taken to clean the gcc
>> >> specific attributes and use the the macros instead.
>> >>
>> >> Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
>> >> ---
>> >>
>> >>  security/selinux/include/security.h | 3 ++-
>> >>  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > From what I can tell this should still work with both the LLVM and Intel
>> > compilers, is that correct?
>>
>> That's the idea of the compiler-agnostic attribute macros.
>
> I just wanted to make sure as I personally only really use gcc and don't
> pretend to be up on all the details regarding other compilers.
>
>> Interestingly, only include/linux/compiler-gcc.h defines __packed.
>
> From what I could tell by looking at the code, the other compilers all define
> __GNUC__ so they get the __packed macro as part of the gcc configuration.  I
> believe the LLVM and Intel compilers would only need to redefine __packed if
> they wanted/needed a different definition.
>
>> As it's already in heavy use, I can only assume both LLVM and the Intel
>> compilers handle both "__packed" (without a special definition) and the
>> gcc-specific "__attribute__((packed))".
>
> Yep, seems reasonable.  I'll go ahead and apply the patch.
>
> --
> paul moore
> www.paul-moore.com
>
