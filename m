Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaE2L6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:58:15 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49854 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaE2L6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:58:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140528190400.GR14863@redhat.com>
References: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
	<20140527030058.GB2372@darkstar.nay.redhat.com>
	<CAL01qpvqa-8u2MZ=8wE8gsiprFLbN4U3AbEX9+h7FuemXNR93Q@mail.gmail.com>
	<20140528020935.GB2820@darkstar.nay.redhat.com>
	<20140528094712.GL2820@darkstar.nay.redhat.com>
	<20140528155104.GW10771@sgi.com>
	<20140528190400.GR14863@redhat.com>
Date: Thu, 29 May 2014 12:58:12 +0100
Message-ID: <CAL01qptPFR_2eAfdjBXN+3Xsm3eOcqnwW5L2ym+teQNTtDuCGQ@mail.gmail.com>
Subject: Re: [PATCH] export efi.flags to sysfs
From: "Fleming, Matt" <matt.fleming@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Dave Young <dyoung@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 2014 20:04, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, May 28, 2014 at 10:51:04AM -0500, Alex Thorlton wrote:
>
> [..]
>> A side note, though:  We're going to have to figure out some way to
>> determine whether or not to apply the old_map quirk on during boot
>> anyway, so if it's easiest for you to just determine how the original
>> kernel was booted and key off of that, then I wouldn't worry about
>> finding a different method to get the firmware version in userspace,
>> unless there are other reasons for you to do it that way.
>
> Agreed. Let kernel and firmware figure it out when to apply quirk and
> user space should not worry about firmware version.
>
> I liked the other approach better where user space just needs to know
> if 1:1 mapping are in effect or not and take decision based on that.

The problem with going down this route is that if we ever change the
way we map the EFI regions in the kernel corresponding changes will be
required for kexec-tools. That's not ideal.

Kexec-tools should not be interpreting /sys/firmware/efi/runtime-map/
any further than building a memory map, i.e. it has to understand how
to build a memory region descriptor but it shouldn't care what
*values* are in them.
