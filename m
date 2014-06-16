Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbaFPRuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:50:25 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:45614 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaFPRuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:50:22 -0400
MIME-Version: 1.0
In-Reply-To: <539F2B2D.6050105@gmx.de>
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
 <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
 <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
 <539F2B2D.6050105@gmx.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jun 2014 10:50:01 -0700
Message-ID: <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Eric Paris <eparis@redhat.com>
Cc: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc: eparis.  This might be a new audit bug.

On Mon, Jun 16, 2014 at 10:36 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 06/16/2014 07:32 PM, Andy Lutomirski wrote:
>> On Mon, Jun 16, 2014 at 10:29 AM, Richard Weinberger <richard@nod.at> wrote:
>>> Am 16.06.2014 19:25, schrieb Andy Lutomirski:
>>>> On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
>>>> <richard.weinberger@gmail.com> wrote:
>>>>> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>>> $ cat syscall.c
>>>>>> #include <unistd.h>
>>>>>> #include <sys/syscall.h>
>>>>>> int main(){return syscall(1000)!=-1;}
>>>>
>>>> What architecture are you building for?  On i386 and x86_64, 1000
>>>> shouldn't be big enough to trigger this.
>>>
>>> Toralf, is this an UML kernel?
>>>
>>
>> I'm also interested in the userspace architecture.  If it's x32
>> userspace, then I'm not surprised that there's a problem.
>
> It is a x86 system (ThinkPad T420) - not x32.

I don't think this is CVE-2014-3917.  It looks like you're hitting this BUG:

BUG_ON(context->in_syscall || context->name_count);

Can you send the output of:

auditctl -l [run as root]

and

dmesg |grep audit

Are you using ptrace or anything like that (e.g. strace) when you
trigger this?  Are you using a funny glibc version?  Do you have
selinux or something like that enabled?

--Andy
