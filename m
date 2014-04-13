Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaDMKOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 06:14:46 -0400
Received: from mout.gmx.net ([212.227.15.15]:59572 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaDMKOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 06:14:44 -0400
MIME-Version: 1.0
Message-ID: <trinity-516ff83e-4833-4dad-856a-dd0597993837-1397384072115@3capp-gmx-bs62>
From: Alexander.Kleinsorge@gmx.de
To: "Andi Kleen" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Aw: Re: new module to check constant memory for corruption
Content-Type: text/plain; charset=UTF-8
Date: Sun, 13 Apr 2014 12:14:32 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <87eh12hr1t.fsf@tassilo.jf.intel.com>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>,
 <87eh12hr1t.fsf@tassilo.jf.intel.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:JEmaSVgf18Am6MLzHP7kjEBkyiGExS5Wm0rrJXy4+yI
 kFIxiPYK+WRPwmiHAqhAbQUhKuejgoxdoH0o+9lV77A2HSe5VS
 LAnO7Abw3YOt3ZU/REUVUkL18CVNZho1xBsidxKZa8+67CwSK+
 cmAdy/h0TV8SZyOjYewlocEtVEYEdfZdM8kuqL8d0WATGjHaSw
 7wvxurHGXSPf1R1CJIUwB59lVGVgrlUf7pg20+jEWamBQ/1MuJ
 o1nxumB2w4wV58e+YDFN+k6H5kjllgzyXxPvWskUmDI96ggsnU 5q449M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

the module considers only the adress range between: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rodata").
this range has a typical size of 10..20 mb (depending on kernel-version and arch). 
see files: linux-3.*\arch\x86\mm\init_32.c + init_64.c
function: void mark_rodata_ro(void)
"Write protecting the kernel text: %luk\n"
"Write protecting the kernel read-only data: %luk\n"
dmesg | grep protecting

your question: there are no writes in this write protected adress range (e.g. kernel code).
my idea is to calculate a checksum (xor is fastest) over this range and check later (periodically) if its unchanged.
see source code download (5 KB): http://tauruz.homeip.net/ramcheck.tgz
the code is working fine and the checksum is (as expected) constant (at least for many hours).

regards, Alexander


Gesendet: Sonntag, 13. April 2014 um 05:00 Uhr
Von: "Andi Kleen" <andi@firstfloor.org>
An: Alexander.Kleinsorge@gmx.de
Cc: linux-kernel@vger.kernel.org
Betreff: Re: new module to check constant memory for corruption
Alexander.Kleinsorge@gmx.de writes:

> ramcheck kernel module
> new module to check constant memory for corruption
>
> detect corruption of constant kernel memory (text and data) periodically.
> runtime costs about 1..2 ms per sec (about 10 mb with 5 mb/ms),
> which is distributed over 8 (BLOCKS) time partitions (less than half
> ms per sec).
> in case of checksum (xor) error, an kernel log is posted.
> manual trigger via /proc/ramcheck is possible.
> range: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rodata")


Can you explain how this works? How does it handle legal writes?

If it just checks its own memory it could be done in user space.

-Andi

--
ak@linux.intel.com -- Speaking for myself only
