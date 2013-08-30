Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3H3PiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:38:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52294 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab3H3PiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:38:00 -0400
Message-ID: <5220BC1A.3030108@zytor.com>
Date: Fri, 30 Aug 2013 08:36:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled DYNAMIC_FTRACE
References: <5217908E.2040702@siemens.com>
In-Reply-To: <5217908E.2040702@siemens.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 09:40 AM, Jan Kiszka wrote:
> Hi all,
> 
> 32-bit kernels currently crash/reboot in early microcode loading when
> non-dynamic function tracing is enabled. Several functions in that path
> get instrumented with mcount, but its non-dynamic implementation does
> not work before paging is enabled (it accesses global variables at wrong
> addresses).
> 
> Below some hunks to get it working again - at least in the absence of
> any microcode in the initrd. Marking all involved functions as __init is
> another option (as __init implies notrace). But I bet there is more
> hidden. I see e.g. a pr_warn() in find_cpio_init that should trigger the
> issue as well if we hit the error it reports (btw. printing at this
> point of the boot should not work anyway, should it?).
> 
> Better ideas?
> 
> Jan
> 

A better idea would be for the mcount/__fentry__ function to simply
return until the function tracing stuff is actually ready.

	-hpa


