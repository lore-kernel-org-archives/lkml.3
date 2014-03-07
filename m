Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaCGJv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:51:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56803 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaCGJvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:51:21 -0500
Message-ID: <8B88CF1FBC3B4B77AE46AE9CEEC28C5E@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Jeff Leung" <jleung@v10networks.ca>,
        "Brian Wong" <draconicpenguin1@yahoo.com>,
        "KY Srinivasan" <kys@microsoft.com>, <linux-kernel@vger.kernel.org>
Cc: "Abhishek Gupta \(LIS\)" <abgupta@microsoft.com>
References: <531813B4.7060205@yahoo.com> <53181489.6040000@yahoo.com> <B0EFDC0724C0400DBC0931FD129D1859@local.st.by> <921422bfecda43e9baaa42077509a61d@BY2PR03MB299.namprd03.prod.outlook.com> <A1DA03FDF9C54AD3BCD66D02EA8CA68A@local.st.by> <5318BA6F.3080604@yahoo.com> <A70AC0C1B7E7FD478A6BF19705461AA0014B05@IMBER.smb.curriegrad2004.ca>
Subject: Re: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
Date: Fri, 7 Mar 2014 12:51:17 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

VVM>>>>
VVM>>>>  Question to Linux kernel team: may be patch
VVM>>>> >>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
VVM>>>> can solve problems with dynamic memory hot add in Hyper-V VMs with Linux OS ?
VVM>>>>
K.Y.S>>>
K.Y.S>>>  I will try to get my in-context onlining patches accepted upstream.
K.Y.S>>>

VVM>>
VVM>> Thanks! Feature dynamic memory hot add in Hyper-V VMs with Linux OS  -- is very usefull for Hyper-V sysadmins
VVM> Stable work for this feature -- must be hi-priority task for developers
VVM>
  +
B.W.>>
B.W.>> So can I expect to see this patched by the next kernel version?
B.W.>>


J.L.>
J.L.> I would hold your breath on this one.
J.L.>


J.L.>
J.L.> The maintainers of the memory subsystem has rejected the patch exposing certain functions
J.L.>

  When?

Please resend to me message from maintainer with "reject"

(
  I again search in my archive of messages from this mail list, and not found message[s],
about Brian Wong write
)

J.L.>
J.L.> so hv_balloon can online the newly added memory to the system.
J.L.> They think that having udev to handle such events is a better place.
J.L.>

  Look like You read "Bug 979257" . . .


J.L.> And in case if somebody hasn't posted it here, this is the udev rule that KY has given to me in the past:
==
SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f /sys$devpath/state ] && echo online > /sys$devpath/state'"
==

  Add to Youre collection of udev rules:

http://social.technet.microsoft.com/Forums/windowsserver/en-US/21519c00-47d4-44a4-b2d3-64cd3098849e/rhel-70-centos-70-rhel-65-centos-65-rhel-64-centos-64-include-support-for-hyperv?forum=linuxintegrationservices
==
Michael Kelley:
The VM crash   . . . ( VVM: some details skipped by me ) should be fixed by adding the udev rule. The udev rule looks
like:
SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory*[0-9]", TEST=="/sys$devpath/state",
RUN+="/bin/sh -c 'echo online > /sys$devpath/state'"


Nikolay Pushkarev:
Following rule works slightly faster for me (assuming that memory0 bank always in online state):

SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory[1-9]*", RUN+="/bin/cp
/sys$devpath/../memory0/state /sys$devpath/state"
==


 And another topic in russian:
http://social.technet.microsoft.com/Forums/ru-RU/addd8d0a-fe38-4679-b0be-c355e12b5b32/centos-65-?forum=virtualizationru
( But You can use Google translate service or vice versa )



Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


----- Original Message ----- 
From: "Jeff Leung"
To: "Brian Wong"; "Victor Miasnikov" ; "KY Srinivasan" ( zzzzzzzzzz (at) microsoft.com ); linux-kernel@vger.kernel.org
Cc: "Abhishek Gupta (LIS)" ( zzzzzzzzz (at) microsoft.com)
Sent: Thursday, March 06, 2014 9:25 PM
Subject: RE: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2]
Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:


B.W.> So can I expect to see this patched by the next kernel version?

I would hold your breath on this one.
The maintainers of the memory subsystem has rejected the patch exposing certain functions
so hv_balloon can online the newly added memory to the system.
They think that having udev to handle such events is a better place.

And in case if somebody hasn't posted it here, this is the udev rule that KY has given to me in the past:

SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f
/sys$devpath/state ] && echo online > /sys$devpath/state'"

> --




----- Original Message ----- 
From: "Brian Wong"
To: "Victor Miasnikov"; "KY Srinivasan" ( zzzzzzzzzz (at) microsoft.com ); linux-kernel@vger.kernel.org
Cc: "Abhishek Gupta (LIS)"  ( zzzzzzzzz (at) microsoft.com)
Sent: Thursday, March 06, 2014 9:11 PM
Subject: Re: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2]
Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:


  . . .

VVM>>>
VVM>>>  Question to Linux kernel team: may be patch
VVM>>> >>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
VVM>>> can solve problems with dynamic memory hot add in Hyper-V VMs with Linux OS ?
VVM>>>
 K.Y.S>>
 K.Y.S>>  I will try to get my in-context onlining patches accepted upstream.
 K.Y.S>>
VVM>
VVM> Thanks!
VVM>
VVM> Feature dynamic memory hot add in Hyper-V VMs with Linux OS  -- is very usefull for Hyper-V sysadmins
VVM> Stable work for this feature -- must be hi-priority task for developers
VVM>


So can I expect to see this patched by the next kernel version?

-- 
Brian Wong
http://www.fierydragonlord.com
--





----- Original Message ----- 
From: "KY Srinivasan"
To: "Victor Miasnikov"; linux-kernel@vger.kernel.org; "Brian Wong"
Cc: "Abhishek Gupta (LIS)"
Sent: Thursday, March 06, 2014 1:23 PM
Subject: RE: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2]
Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:


Victor,

I will try to get my in-context onlining patches accepted upstream.

K. Y

> -----Original Message-----
> From: Victor Miasnikov [mailto:vvm@tut.by]
> Sent: Thursday, March 6, 2014 3:38 PM
> To: linux-kernel@vger.kernel.org; Brian Wong
> Cc: Abhishek Gupta (LIS); KY Srinivasan
> Subject: Re: Linux does not use more than the startup RAM under Hyper-V
> with dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online
> the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
>


----- Original Message ----- 
From: "Victor Miasnikov"
To:  linux-kernel@vger.kernel.org; "Brian Wong"
Cc: "Abhishek Gupta (LIS)" ( zzzzzzzzzzzzzzz (at) microsoft.com>; "KY Srinivasan" zzzzzzzzzzz (at) microsoft.com
Sent: Thursday, March 06, 2014 1:07 PM
Subject: Re: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2]
Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:

Hi!

 Short:

 Question to Linux kernel team:

may be patch

>>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"

can solve problems with dynamic memory hot add in Hyper-V VMs with Linux OS ?



 Full:

BW>> .., if I set the startup memory to 512 MB, and enable dynamic
BW>> memory with a minimum of 512 MB and a maximum of 8192 MB,
BW>>  the system will never allocate than 512 MB of physical memory

BW>>
BW>> Have I encountered a bug in the Hyper-V balloon driver?
BW>>

 Unfortunately,  It's long story . . . :-(

a)

 I already ( on January 09, 2014 2:18 PM )  write about problems with "Online the hot-added memory"  in "user space" see
P.P.S.

b)

  See

Bug 979257 -[Hyper-V][RHEL6.5][RFE]in-kernel online support for memory hot-add
https://bugzilla.redhat.com/show_bug.cgi?id=979257

 (  Info from this topic may be interessant not only for RedHat users )


b2)

 Detail about pathes related problem "Online the hot-added memory"  in "user space" :

>>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
>>>
>>>
>>> === 0001-Drivers-base-memory-Export-functionality-for-in-kern.patch
>>>  . . .
>>> +/*
>>> + * Given the start pfn of a memory block; bring the memory
>>> + * block online. This API would be useful for drivers that may
>>> + * want to bring "online" the memory that has been hot-added.
>>> + */
>>> +
>>> +int online_memory_block(unsigned long start_pfn) {  struct mem_section
>>> +*cur_section;  struct memory_block *cur_memory_block;
>>>
>>>  . . .
>>> ===
>>>
>>>
>>> ==
>>>  . . .
>>> == 0002-Drivers-hv-balloon-Online-the-hot-added-memory-in-co.patch
>>>   . . .
>>>    /*
>>> -   * Wait for the memory block to be onlined.
>>> -   * Since the hot add has succeeded, it is ok to
>>> -   * proceed even if the pages in the hot added region
>>> -   * have not been "onlined" within the allowed time.
>>> +   * Before proceeding to hot add the next segment,
>>> +   * online the segment that has been hot added.
>>>     */
>>> -  wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
>>> +  online_memory_block(start_pfn);
>>>
>>>   }




c)

  Before apply patches ( see in P.S. about native udev-script) we are need use one of this methods:

http://social.technet.microsoft.com/Forums/en-US/8e1994b9-9ca1-4411-ad8e-25e6b1ee28e1/dynamic-memory-on-linux-vm?forum=linuxintegrationservices



c1)

"/bin/cp method" by Nikolay Pushkarev :

Following udev rule works slightly faster for me (assuming that memory0 bank always in online state):

SUBSYSTEM=="memory", ACTION=="add", DEVPATH=="/devices/system/memory/memory[1-9]*",
RUN+="/bin/cp /sys$devpath/../memory0/state /sys$devpath/state"}}

( VVM : of course all need be place in one line, 2 line in this msg. -- only for good visual formating reasons )


c2)

udev rule using "putarg" by Nikolay Pushkarev :


 Even "/bin/cp method" udev rule work time to time not as need :-(


As a result, Nikolay Pushkarev write a program putarg.c, that is even faster than "/bin/cp method" :

==
#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <string.h>
int main(int argc, char** argv) {
  int i, fd;
  if (argc < 2) return 0;
  if ((fd = open(argv[1], O_RDWR)) < 0) return 1;
  for (i = 2; i < argc; i++) {
    if (write(fd, argv[i], strlen(argv[i])) < 0) {
      close(fd);
      return i;
    }
  }
  close(fd);
  return 0;
}
==

 The first argument - the name of the output file ,
and argument number 2 ( and all subsequent (  if exist ) ) - are text that are wiil be written in output file.


 Compile source code to executable file by run command:
gcc -o putarg -s putarg.c

The resulting binary need be placed an accessible location , such as /usr/bin, or wherever you want.


Now udev rule using "putarg" can be written as :

SUBSYSTEM=="memory", ACTION=="add", RUN+="/usr/bin/putarg /sys$devpath/state online"


This complex solutions ( compiled file and udev-rule ) works exceptionally fast.





Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.

Nikolay Pushkarev about standart udev-script :

{{

Strange, that the native udev-script

SUBSYSTEM=="memory", ACTION=="add", ATTR{state}="online"


triggered somehow through time ( VVM: very often not work as need )


}}



P.P.S.

----- Original Message ----- 
From: "Victor Miasnikov"
To: "Dan Carpenter"; "K. Y. Srinivasan" ; <linux-kernel@vger.kernel.org>
Cc: "Greg KH" ; <devel@linuxdriverproject.org>; <olaf (at) aepfle.de>; ""Andy Whitcroft"" <zzzzzzzzzzzz (at)
canonical.com>;
<jasowang (at) redhat.com>
Sent: Thursday, January 09, 2014 2:18 PM
Subject: RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
Implement the file copy service


Hi!

> Is there no way we could implement file copying in user space?


  For "file copy service"  "user space"  may be pretty good

But I ( and other Hyper-V sysadmin)  see non-Ok ( in "political correct" terminalogy) results with "hv: balloon: Online
the hot-added memory" in "user space"


==
 [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
==


 What news?  Roadmap?


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/




P.P.S.

----- Original Message ----- 
From: "Brian Wong"
To: <linux-kernel@vger.kernel.org>
Sent: Thursday, March 06, 2014 9:24 AM
Subject: Re: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled


On 3/6/2014 1:20 AM, Brian Wong wrote:

   . . .

> The kernel is built with the full set of Hyper-V drivers, including the
> key "Microsoft Hyper-V Balloon Driver" as well as memory hot-add and
> hot-remove functionality. This is happening with both the Gentoo-patched
> 3.10.32 kernel and the vanilla 3.13.5 kernel. The host machine has a
> total of 24 GB of memory.
>
> For now, I am working around the issue by starting the VM with the
> startup memory set to the maximum and letting Hyper-V take the usused
> memory back when it is not in use. The VM will then get the extra memory
> when it needs it.
>
> Have I encountered a bug in the Hyper-V balloon driver?
>

  . . .



