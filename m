Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaCFKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:25:27 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:51089
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751358AbaCFKYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:24:49 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Victor Miasnikov <vvm@tut.by>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brian Wong <draconicpenguin1@yahoo.com>
CC: "Abhishek Gupta (LIS)" <abgupta@microsoft.com>
Subject: RE: Linux does not use more than the startup RAM under Hyper-V with
 dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online the
 hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
Thread-Topic: Linux does not use more than the startup RAM under Hyper-V
 with dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online the
 hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
Thread-Index: AQHPOSP5fYjCCuFlTk+SHEx0nTcLNZrT2d3Q
Date: Thu, 6 Mar 2014 10:23:46 +0000
Message-ID: <921422bfecda43e9baaa42077509a61d@BY2PR03MB299.namprd03.prod.outlook.com>
References: <531813B4.7060205@yahoo.com> <53181489.6040000@yahoo.com>
 <B0EFDC0724C0400DBC0931FD129D1859@local.st.by>
In-Reply-To: <B0EFDC0724C0400DBC0931FD129D1859@local.st.by>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.192.124.81]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(479174003)(189002)(199002)(24454002)(13464003)(51704005)(90146001)(56816005)(65816001)(87936001)(74706001)(47446002)(79102001)(80022001)(63696002)(95666003)(74316001)(97186001)(15202345003)(4396001)(51856001)(81686001)(19580395003)(59766001)(92566001)(54316002)(87266001)(76482001)(94946001)(86612001)(56776001)(19580405001)(74876001)(83322001)(47976001)(54356001)(74502001)(80976001)(69226001)(81542001)(81342001)(76786001)(94316002)(76796001)(46102001)(95416001)(76576001)(53806001)(85852003)(83072002)(15975445006)(50986001)(49866001)(16601075003)(74366001)(66066001)(47736001)(77982001)(2656002)(86362001)(93136001)(85306002)(31966008)(81816001)(74662001)(97336001)(93516002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB223;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.192.124.81;FPR:AEAFFDC4.A5EE9FC9.72DB7D72.56BCE9FF.20724;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> Hi!
> 
>  Short:
> 
>  Question to Linux kernel team:
> 
> may be patch
> 
> >>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in
> context"
> 
> can solve problems with dynamic memory hot add in Hyper-V VMs with Linux
> OS ?
> 
> 
> 
>  Full:
> 
> BW>> .., if I set the startup memory to 512 MB, and enable dynamic
> BW>> memory with a minimum of 512 MB and a maximum of 8192 MB,  the
> BW>> system will never allocate than 512 MB of physical memory
> 
> BW>>
> BW>> Have I encountered a bug in the Hyper-V balloon driver?
> BW>>
> 
>  Unfortunately,  It's long story . . . :-(
> 
> a)
> 
>  I already ( on January 09, 2014 2:18 PM )  write about problems with "Online
> the hot-added memory"  in "user space" see P.P.S.
> 
> b)
> 
>   See
> 
> Bug 979257 -[Hyper-V][RHEL6.5][RFE]in-kernel online support for memory
> hot-add
> https://bugzilla.redhat.com/show_bug.cgi?id=979257
> 
>  (  Info from this topic may be interessant not only for RedHat users )
> 
> 
> b2)
> 
>  Detail about pathes related problem "Online the hot-added memory"  in
> "user space" :
> 
> >>> [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in
> context"
> >>>
> >>>
> >>> === 0001-Drivers-base-memory-Export-functionality-for-in-kern.patch
> >>>  . . .
> >>> +/*
> >>> + * Given the start pfn of a memory block; bring the memory
> >>> + * block online. This API would be useful for drivers that may
> >>> + * want to bring "online" the memory that has been hot-added.
> >>> + */
> >>> +
> >>> +int online_memory_block(unsigned long start_pfn) {  struct
> >>> +mem_section *cur_section;  struct memory_block
> *cur_memory_block;
> >>>
> >>>  . . .
> >>> ===
> >>>
> >>>
> >>> ==
> >>>  . . .
> >>> == 0002-Drivers-hv-balloon-Online-the-hot-added-memory-in-co.patch
> >>>   . . .
> >>>    /*
> >>> -   * Wait for the memory block to be onlined.
> >>> -   * Since the hot add has succeeded, it is ok to
> >>> -   * proceed even if the pages in the hot added region
> >>> -   * have not been "onlined" within the allowed time.
> >>> +   * Before proceeding to hot add the next segment,
> >>> +   * online the segment that has been hot added.
> >>>     */
> >>> -  wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
> >>> +  online_memory_block(start_pfn);
> >>>
> >>>   }
> 
> 
> 
> 
> c)
> 
>   Before apply patches ( see in P.S. about native udev-script) we are need use
> one of this methods:
> 
> http://social.technet.microsoft.com/Forums/en-US/8e1994b9-9ca1-4411-
> ad8e-25e6b1ee28e1/dynamic-memory-on-linux-
> vm?forum=linuxintegrationservices
> 
> 
> 
> c1)
> 
> "/bin/cp method" by Nikolay Pushkarev :
> 
> Following udev rule works slightly faster for me (assuming that memory0
> bank always in online state):
> 
> SUBSYSTEM=="memory", ACTION=="add",
> DEVPATH=="/devices/system/memory/memory[1-9]*",
> RUN+="/bin/cp /sys$devpath/../memory0/state /sys$devpath/state"}}
> 
> ( VVM : of course all need be place in one line, 2 line in this msg. -- only for
> good visual formating reasons )
> 
> 
> c2)
> 
> udev rule using "putarg" by Nikolay Pushkarev :
> 
> 
>  Even "/bin/cp method" udev rule work time to time not as need :-(
> 
> 
> As a result, Nikolay Pushkarev write a program putarg.c, that is even faster
> than "/bin/cp method" :
> 
> ==
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/ioctl.h>
> #include <string.h>
> int main(int argc, char** argv) {
>   int i, fd;
>   if (argc < 2) return 0;
>   if ((fd = open(argv[1], O_RDWR)) < 0) return 1;
>   for (i = 2; i < argc; i++) {
>     if (write(fd, argv[i], strlen(argv[i])) < 0) {
>       close(fd);
>       return i;
>     }
>   }
>   close(fd);
>   return 0;
> }
> ==
> 
>  The first argument - the name of the output file , and argument number 2 (
> and all subsequent (  if exist ) ) - are text that are wiil be written in output file.
> 
> 
>  Compile source code to executable file by run command:
> gcc -o putarg -s putarg.c
> 
> The resulting binary need be placed an accessible location , such as /usr/bin,
> or wherever you want.
> 
> 
> Now udev rule using "putarg" can be written as :
> 
> SUBSYSTEM=="memory", ACTION=="add", RUN+="/usr/bin/putarg
> /sys$devpath/state online"
> 
> 
> This complex solutions ( compiled file and udev-rule ) works exceptionally
> fast.
> 
> 
> 
> 
> 
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/
> 
> P.S.
> 
> Nikolay Pushkarev about standart udev-script :
> 
> {{
> 
> Strange, that the native udev-script
> 
> SUBSYSTEM=="memory", ACTION=="add", ATTR{state}="online"
> 
> 
> triggered somehow through time ( VVM: very often not work as need )
> 
> 
> }}
> 
> 
> 
> P.P.S.
> 
> ----- Original Message -----
> From: "Victor Miasnikov"
> To: "Dan Carpenter"; "K. Y. Srinivasan" ; <linux-kernel@vger.kernel.org>
> Cc: "Greg KH" ; <devel@linuxdriverproject.org>; <olaf (at) aepfle.de>;
> ""Andy Whitcroft"" <zzzzzzzzzzzz (at) canonical.com>; <jasowang (at)
> redhat.com>
> Sent: Thursday, January 09, 2014 2:18 PM
> Subject: RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory
> "in context" Re: [PATCH 1/1] Drivers: hv:
> Implement the file copy service
> 
> 
> Hi!
> 
> > Is there no way we could implement file copying in user space?
> 
> 
>   For "file copy service"  "user space"  may be pretty good
> 
> But I ( and other Hyper-V sysadmin)  see non-Ok ( in "political correct"
> terminalogy) results with "hv: balloon: Online
> the hot-added memory" in "user space"
> 
> 
> ==
>  [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context"
> ==
> 
> 
>  What news?  Roadmap?
> 
> 
> Best regards, Victor Miasnikov
> Blog:  http://vvm.blog.tut.by/
> 
> 
> 
> 
> P.P.S.
> 
> ----- Original Message -----
> From: "Brian Wong"
> To: <linux-kernel@vger.kernel.org>
> Sent: Thursday, March 06, 2014 9:24 AM
> Subject: Re: Linux does not use more than the startup RAM under Hyper-V
> with dynamic memory enabled
> 
> 
> On 3/6/2014 1:20 AM, Brian Wong wrote:
> 
>    . . .
> 
> > The kernel is built with the full set of Hyper-V drivers, including the
> > key "Microsoft Hyper-V Balloon Driver" as well as memory hot-add and
> > hot-remove functionality. This is happening with both the Gentoo-patched
> > 3.10.32 kernel and the vanilla 3.12.5 kernel. The host machine has a
> > total of 24 GB of memory.
> >
> > For now, I am working around the issue by starting the VM with the
> > startup memory set to the maximum and letting Hyper-V take the usused
> > memory back when it is not in use. The VM will then get the extra memory
> > when it needs it.
> >
> > Have I encountered a bug in the Hyper-V balloon driver?
> >
> 
> Just a correction: the vanilla kernel version is 3.13.5, not 3.12.5.
> Sorry for any confusion.
> 
> --
> Brian Wong
> http://www.fierydragonlord.com
> --
> 
> 
> 
> ----- Original Message -----
> From: "Brian Wong"
> To: <linux-kernel@vger.kernel.org>
> Sent: Thursday, March 06, 2014 9:20 AM
> Subject: Linux does not use more than the startup RAM under Hyper-V with
> dynamic memory enabled
> 
> I'm new to LKML, so please don't be too hard on me :)
> 
> I'm running Gentoo Linux under Microsoft Client Hyper-V on Windows 8.1
> Pro, and I've noticed some odd behavior with respect to dynamic memory
> (aka memory ballooning). The system will never use more than the startup
> memory defined in the virtual machine's settings.
> 
> ( VVM: typewriting error viRtual fixed by me, for best search in future )
> 
> For example, if I set the startup memory to 512 MB, and enable dynamic
> memory with a minimum of 512 MB and a maximum of 8192 MB, the system
> will never allocate than 512 MB of physical memory, despite Hyper-V
> assigning more memory to the VM and the added memory being visible in
> the output of "free" and "htop". Attempting to use more memory causes
> the system to start paging to swap, rather than actually allocating the
> memory above the startup memory assigned to the VM.
> 
> The kernel is built with the full set of Hyper-V drivers, including the
> key "Microsoft Hyper-V Balloon Driver" as well as memory hot-add and
> hot-remove functionality. This is happening with both the Gentoo-patched
> 3.10.32 kernel and the vanilla 3.12.5 kernel. The host machine has a
> total of 24 GB of memory.
> 
> (
>   Brian Wong wrote On 3/6/2014 1:20 AM:
>  Just a correction: the vanilla kernel version is 3.13.5, not 3.12.5. )
> )
> 
> For now, I am working around the issue by starting the VM with the
> startup memory set to the maximum and letting Hyper-V take the usused
> memory back when it is not in use. The VM will then get the extra memory
> when it needs it.
> 
> Have I encountered a bug in the Hyper-V balloon driver?
> 
> --
> Brian Wong
> http://www.fierydragonlord.com
> --
> 
> 
> 

