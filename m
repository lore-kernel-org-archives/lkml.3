Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaEAPf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:35:57 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64549 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaEAPf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140501150549.GA24388@thunk.org>
References: <20140428195913.E0A0143994596@oldenburg.str.redhat.com>
 <20140428214112.GC7857@thunk.org> <535FE68C.8060002@redhat.com>
 <20140429182610.GA19325@thunk.org> <53616293.3080308@mit.edu>
 <20140501020627.GA25248@thunk.org> <1be5350d-89f9-44b9-8d1b-e3e591741940@email.android.com>
 <20140501150549.GA24388@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 08:35:35 -0700
Message-ID: <CALCETrUQRqKEbWps5Nxqk57vCYmuvcA6pYAL7OiqJy8sE8yh=g@mail.gmail.com>
Subject: Re: [PATCH] random: Add "initialized" variable to proc
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Florian Weimer <fweimer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <kees@outflux.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 8:05 AM,  <tytso@mit.edu> wrote:
> On Wed, Apr 30, 2014 at 09:05:00PM -0700, H. Peter Anvin wrote:
>>
>> Giving the guest a seed would be highly useful, though.  There are a
>> number of ways to do that; changing the boot protocol is probably
>> only useful if Qemu itself bouts the kernel as opposed to an in-VM
>> bootloader.
>
> So how about simply passing a memory address and an optional offset on
> the boot command line?  That way the hypervisor can drop the seed in
> some convenient real memory location, and the kernel can just copy it
> someplace safe, or in the case of kernel ASLR, the relocator can use
> it to seed its CRNG, and then after it relocates the kernel, it can
> crank the CRNG to pass a seed to the kernel's urandom driver.
>
> That way, we don't have to do something which is ACPI or DT dependent.
> Maybe there will be embedded architectures where using DT might be
> more convenient, but this would probably be simplest for KVM/qumu-based
> VM's, I would think.

One problem with passing a seed in memory like this is that it
provides no benefit if the guest reboots without restarting the
hypervisor.  Using an MSR or something avoids that issue.

Passing an address in I/O space that can be read to synchronously
obtain a seed would work, but it could still be messy to get the
address to propagate through the booatloader and the reboot process.

--Andy
