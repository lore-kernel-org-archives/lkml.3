Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352Ab3GSMrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 08:47:39 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64297 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755759Ab3GSMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:47:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak <ak@linux.intel.com>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
Date: Fri, 19 Jul 2013 14:57:33 +0200
Message-ID: <5778434.g68SM8T2By@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51E87DD4.3000907@zytor.com>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <51E8696A.7090406@intel.com> <51E87DD4.3000907@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 18, 2013 04:44:20 PM H. Peter Anvin wrote:
> On 07/18/2013 03:17 PM, Rafael J. Wysocki wrote:
> >>
> >> alias x86cpu:vendor:*:family:*:model:*:feature:*0081* crct10dif_pclmul
> >>
> >> This should cause udev to load the crct10dif_pclml module when cpu
> >> support the PCLMULQDQ (feature code 0081).  I did my testing during
> >> development on 3.10 and the module was indeed loaded.
> >>
> >> However, I found that the following commit under 3.11-rc1 broke
> >> the mechanism after some bisection.
> >>
> >> commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> >> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Date:   Fri May 3 00:26:22 2013 +0200
> >>
> >>      ACPI / processor: Use common hotplug infrastructure
> >>           Split the ACPI processor driver into two parts, one that is
> >>      non-modular, resides in the ACPI core and handles the enumeration
> >>      and hotplug of processors and one that implements the rest of the
> >>      existing processor driver functionality.
> >>      Rafael, can you check and see if this can be fixed so those
> >> optimized
> >> crypto modules for Intel cpu that support them can be loaded?
> > 
> > I think this is an ordering issue between udev startup and the time when
> > devices are registered.
> > 
> > I wonder what happens if you put those modules into the initramfs image?
> > 
> 
> OK, this bothers me on some pretty deep level... a set of changes
> exclusively in drivers/acpi breaking functionality which had nothing to
> do with ACPI, specifically CPU-feature-based module loading.

Well, they are not exclusively in drivers/acpi, they are in drivers/base/cpu.c
too and that most likely is the responsible part.

> Please let me know what the investigation comes up with, or if I need to
> get more directly involved.

I will.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
