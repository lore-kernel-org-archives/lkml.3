Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaDNIDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:03:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:59447 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaDNIDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:03:13 -0400
MIME-Version: 1.0
Message-ID: <trinity-0370530e-fe87-44e0-800c-660c1fc99eff-1397462591198@3capp-gmx-bs45>
From: Alexander.Kleinsorge@gmx.de
To: "Andi Kleen" <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Aw: Re: new module to check constant memory for corruption
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Apr 2014 10:03:11 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <87eh12hr1t.fsf@tassilo.jf.intel.com>
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>,
 <87eh12hr1t.fsf@tassilo.jf.intel.com>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:ylYwep0fbs0k9Slv0JHxmEBLgKW/TH5oR6hV3PtbDXI
 f2OqjkT8WT0sR5xepgTBGSuPHY+cebyeR7NYCqXVovWFlTVC33
 OCRkHUkVFp7UJx7xEHZ2m2RXw8/B5bBTHzwWNLAQmdrbYg4vkh
 AD4lzejhTqr9APRYrOMnwK6s5FBVVhlqzyYmLuXPuJRC4KaP5z
 /wkLzxOs3Xh6yhAzfMWkexUfSGNZDpP/4qPHsLvFeRp14I4FkW
 7I9YnWmrzWuPm+hKeQM29aQWrwxOWGNMadVI1s0Lxv1tr/hCm7 yXwriw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

I would like to ask for your help.
Is there a central kernel function that enables/disables write-protection for kernel memory?
I only know the place, where its write protected at booting for x86/x64.
If there is one place, it would be much easier, as to hook into many places (e.g. ftrace, etc). 

My goal is to verify kernel memory (the constant part), not to rebuild memcheck as a process.
In my Ubuntu 12.04 system, this range has never changed during module-runtime (many hours).
I think in >90% of all systems is no ftrace (etc) changing this range.

So I need either a trigger when to update my reference sum, or to know when ftrace (etc) are really working.
ftrace_enabled = 1 (default) is no indicator, because it is typically on.

Thanks a lot,
Alexander


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
