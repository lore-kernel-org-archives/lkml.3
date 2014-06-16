Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbaFPR70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:59:26 -0400
Received: from mout.gmx.net ([212.227.15.15]:64778 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaFPR7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:59:24 -0400
Message-ID: <539F3077.7040005@gmx.de>
Date: Mon, 16 Jun 2014 19:59:19 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>
CC: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com>
In-Reply-To: <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:JEH/1qnhkiEC5HCZFCWzJJoFj6IwPY7qriU/2r2IqQ051W/eWYJ
 0cVz9Hs6wi/VUmjjhvD6PibDdHzBaAToBqKKnpTGJ6dCu6GY++EFDON3CZLjRv6TiXUhCKY
 cLJak0SkQmC/uxBkB+YW1ZmsJT4sdj8M0KFPFjgNdSU0n98TUyEqkr6P/caxELPOSUGTAhA
 d2+eM52BM16neL1pqZQVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 07:50 PM, Andy Lutomirski wrote:
> cc: eparis.  This might be a new audit bug.
> 
> On Mon, Jun 16, 2014 at 10:36 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> On 06/16/2014 07:32 PM, Andy Lutomirski wrote:
>>> On Mon, Jun 16, 2014 at 10:29 AM, Richard Weinberger <richard@nod.at> wrote:
>>>> Am 16.06.2014 19:25, schrieb Andy Lutomirski:
>>>>> On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
>>>>> <richard.weinberger@gmail.com> wrote:
>>>>>> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>>>>>>> $ cat syscall.c
>>>>>>> #include <unistd.h>
>>>>>>> #include <sys/syscall.h>
>>>>>>> int main(){return syscall(1000)!=-1;}
>>>>>
>>>>> What architecture are you building for?  On i386 and x86_64, 1000
>>>>> shouldn't be big enough to trigger this.
>>>>
>>>> Toralf, is this an UML kernel?
>>>>
>>>
>>> I'm also interested in the userspace architecture.  If it's x32
>>> userspace, then I'm not surprised that there's a problem.
>>
>> It is a x86 system (ThinkPad T420) - not x32.
> 
> I don't think this is CVE-2014-3917.  It looks like you're hitting this BUG:
> 
> BUG_ON(context->in_syscall || context->name_count);
> 
> Can you send the output of:
> 
> auditctl -l [run as root]
> 
> and
> 
> dmesg |grep audit
> 
> Are you using ptrace or anything like that (e.g. strace) when you
> trigger this?  Are you using a funny glibc version?  Do you have
> selinux or something like that enabled?
> 
> --Andy
> 
n22 ~ # auditctl -l
LIST_RULES: exit,never arch=1073741827 (0x40000003) syscall=read,write,open,close,brk,fcntl,dup2,mmap,munmap,stat,fstat,nanosleep,rt_sigaction


no ptrace/strace/SELinux, this is a stable x86 Gentoo Linux, glibc is 2.17, unstable are just KDE + Co.

(@Richard: no. it is not an UML guest, I just stumbled over this while I tried to upgrade an unstable ~x86 Gentoo UML image using chroot)

The trigger is just given by that C one-liner and kernel 3.15 (erm, I did not checked, if 3.14.x hit its too)

-- 

Toralf

