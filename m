Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3FPFkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 01:40:08 -0400
Received: from ozlabs.org ([203.10.76.45]:33020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab3FPFkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 01:40:06 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Linda Walsh <lkml@tlinx.org>, Linux-Kernel <linux-kernel@vger.kernel.org>
Cc: "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: Re: mod filenames != modnames? (inconsistent name changing)
In-Reply-To: <51B7BD57.7050406@tlinx.org>
References: <51B7BD57.7050406@tlinx.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 16 Jun 2013 15:05:29 +0930
Message-ID: <87bo76r526.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh <lkml@tlinx.org> writes:
> Should we have any expectation that a module name and it's filename
> should be equivalent?
>
> I was writing an auto-complete script for modprobe so it wouldn't give
> me the option to double load a module (I'd have to manually type it in if
> I really wanted it).
>
> Trouble is some modules with names w/underscores ('_') change
> register their names with a 'dash'.

But modprobe kvm_intel already works.  Just convert any - to _?

> Would it be too much trouble to ask that the same names be used in
> both places?

Well, you could get kernel developers to rename their files with
underscores.  I've CC'd them.

We use _ because we turn the module names into identifiers; it's also
the most common choice, and having both is just confusing.

> I have about 30 modules loaded now and out of that list,
> 2 are name changes:
>
> acpi_cpufreq  (filename acip-cpufreq.ko)
> kvm_intel     (filename kvm-intel.ko)
>
> If I load a bunch more... I find more that change names.
>
> Could the naming in the modules that do this be made consistent?
>
> Not doing so makes automatically tying a mod-name to it's file
> tend toward being non-deterministic.
>
> Many modules use '-' or '_' without being confused.
> It would be helpful if the few confused modules could
> get their identity straight.  Is there a problem with
> making these names consistent?

It shouldn't break anything to rename them, if there's consensus I'm
happy to create a patch.

Cheers,
Rusty.
