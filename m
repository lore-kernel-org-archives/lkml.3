Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3ASGiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 01:38:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47547 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3ASGiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 01:38:10 -0500
Date: Sat, 19 Jan 2013 06:38:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20130119063808.GN4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3D2F2.3080200@6wind.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:42:10AM +0100, Nicolas Dichtel wrote:
> Hi,
> 
> I'm running a virtual host (kvm/qemu x86 32 bits 16 CPUs, debian
> wheezy) over a x86 64bits target.
> The virtual host has problem during the boot with recent kernels
> (sometimes, daemons crash, but not always, and not always the same
> daemon). Here is an example:
> [    2.150274] input: ImExPS/2 Generic Explorer Mouse as
> /devices/platform/i8042/serio1/input/input3
> udevd[468]: timeout: killing 'firmware.agent' [587]
> 
> udevd[468]: 'firmware.agent' [587] terminated by signal 9 (Killed)
> 
> done.
> 
> [snip]
> 
> [   64.313636] kbd[2563]: segfault at 9fe ip 000009fe sp b758293c
> error 4 in dash[8048000+18000]
> 
> After bisecting, the following commit seems responsible:
> 1d4b4b2994b5fc208963c0b795291f8c1f18becf (x86, um: switch to generic
> fork/vfork/clone)

Er...  Bisect of the guest kernel, I take it?  Could you check if building
the guest !SMP affects anything?
