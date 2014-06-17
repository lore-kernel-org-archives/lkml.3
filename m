Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877AbaFQQT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:19:59 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:56606 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbaFQQT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <53A060F7.2020304@gmx.de>
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
 <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
 <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
 <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com>
 <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com>
 <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com>
 <539F567F.2050802@gmx.de> <539F5702.5050104@nod.at> <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com>
 <53A060F7.2020304@gmx.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Jun 2014 09:19:33 -0700
Message-ID: <CALCETrV9Ee8CMuSBi9ACrfN2r4=P8eMys8i8iY++yQ392UpMDQ@mail.gmail.com>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>, Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 8:38 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 06/16/2014 11:35 PM, Andy Lutomirski wrote:
>> [cc: hpa, x86 list]
>>
>> On Mon, Jun 16, 2014 at 1:43 PM, Richard Weinberger <richard@nod.at> wrote:
>>> Am 16.06.2014 22:41, schrieb Toralf Förster:
>>>> Well, might be the mail:subject should be adapted, b/c the issue can be triggered in a 3.13.11 kernel too.
>>>> Unfortunately it does not appear within an UML guest, therefore an automated bisecting isn't possible I fear.
>>>
>>> You could try KVM. :)
>>
>> Before you do that, just to clarify:
>>
>> What bitness is your kernel?  That is, are you on 32-bit or 64-bit kernel?
>>
>> What bitness is your test case?  'file a.out' will say.
>>
>> What does /proc/cpuinfo say in flags?
>>
>
> tfoerste@n22 ~/tmp $ uname -a
> Linux n22 3.15.1 #4 SMP Tue Jun 17 17:22:22 CEST 2014 i686 Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz GenuineIntel GNU/Linux

So entry_32.S is in play.

> flags           : ... sep ...

And sysenter is in use, barring weird boot-time options.

>
>
>> Can you try the attached patch?  It's only compile-tested.
>>
> applied both on top of 3.14.8 and 3.15.1 - issue solved

So I guess I diagnosed it right.  Yay for reading ugly code.

hpa, should I resend a real emailed patch or is my attached thing ok?
Presumably this, or something like it, should cc: stable and go in
3.16, too.

--Andy
