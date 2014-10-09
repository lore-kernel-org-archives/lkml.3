Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbaJIMwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:52:51 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:48852 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaJIMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:52:42 -0400
Date: Thu, 9 Oct 2014 07:44:16 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141009074416.1480426a@as>
In-Reply-To: <20141009065331.GG12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
	<20141008051059.65566251@as>
	<20141008194955.GF12897@nuc-i3427.alporthouse.com>
	<5435AE71.60304@linux.intel.com>
	<20141009065331.GG12897@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2014 07:53:31 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> # cat /proc/mtrr 
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x080000000 ( 2048MB), size=  256MB, count=1: write-back
> reg02: base=0x08e000000 ( 2272MB), size=   32MB, count=1: uncachable
> reg03: base=0x08d000000 ( 2256MB), size=   16MB, count=1: uncachable
> reg04: base=0x100000000 ( 4096MB), size= 2048MB, count=1: write-back
> reg05: base=0x170000000 ( 5888MB), size=  256MB, count=1: uncachable
> reg06: base=0x16f000000 ( 5872MB), size=   16MB, count=1: uncachable
> reg07: base=0x16e800000 ( 5864MB), size=    8MB, count=1: uncachable
> reg08: base=0x16e600000 ( 5862MB), size=    2MB, count=1: uncachable
> 

Well that's what the kernel thinks is in every CPU.
Could you try installing x86info and running "x86info --mtrr
--all-cpus" while running the broken kernel?
