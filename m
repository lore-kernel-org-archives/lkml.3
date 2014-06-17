Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbaFQPim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:38:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:53021 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbaFQPij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:38:39 -0400
Message-ID: <53A060F7.2020304@gmx.de>
Date: Tue, 17 Jun 2014 17:38:31 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
CC: Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com> <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com> <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com> <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com> <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com> <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com> <539F567F.2050802@gmx.de> <539F5702.5050104@nod.at> <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com>
In-Reply-To: <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:VBMceaAlKE4349eQtx/dHflE8P0gAMowNIMIWe6mqauMQy+TVCJ
 VMZTcMNdlUwXA60yIbr7/J6zf/MbvC1xaniQBiRXDLgiGmMlRhnicdMnE084WS0xDnbH1O3
 jb4HpEHn8gs2bDcqzYKk9e3ECdwfiCTWI/78F+xM1TgqmFlgFoM+9zzX2QC+C2RVb6FCoJP
 BYGhsaru3ydGQfpDav1Eg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 11:35 PM, Andy Lutomirski wrote:
> [cc: hpa, x86 list]
> 
> On Mon, Jun 16, 2014 at 1:43 PM, Richard Weinberger <richard@nod.at> wrote:
>> Am 16.06.2014 22:41, schrieb Toralf Förster:
>>> Well, might be the mail:subject should be adapted, b/c the issue can be triggered in a 3.13.11 kernel too.
>>> Unfortunately it does not appear within an UML guest, therefore an automated bisecting isn't possible I fear.
>>
>> You could try KVM. :)
> 
> Before you do that, just to clarify:
> 
> What bitness is your kernel?  That is, are you on 32-bit or 64-bit kernel?
> 
> What bitness is your test case?  'file a.out' will say.
> 
> What does /proc/cpuinfo say in flags?
> 

tfoerste@n22 ~/tmp $ uname -a                 
Linux n22 3.15.1 #4 SMP Tue Jun 17 17:22:22 CEST 2014 i686 Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz GenuineIntel GNU/Linux
tfoerste@n22 ~/tmp $ file a.out               
a.out: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.16, not stripped
tfoerste@n22 ~/tmp $ cat /proc/cpuinfo           
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz
stepping        : 7
microcode       : 0x29
cpu MHz         : 800.000
cache size      : 3072 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 5183.33
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


> Can you try the attached patch?  It's only compile-tested.
> 
applied both on top of 3.14.8 and 3.15.1 - issue solved 
Thx

> To hpa, etc:  It appears that entry_32.S is missing any call to the
> audit exit hook on the badsys path.  If I'm diagnosing this bug report
> correctly, this causes OOPSes.
> 
> The the world at large: it's increasingly apparent that no one (except
> maybe the blackhats) has ever scrutinized the syscall auditing code.
> This is two old severe bugs in the code that have probably been there
> for a long time.

and now there are 2 less than before - this is the good news, or ?


-- 
Toralf

