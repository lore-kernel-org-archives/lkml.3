Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaAQQ4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:56:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57660 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaAQQ4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:56:31 -0500
Message-ID: <52D95F77.4030908@zytor.com>
Date: Fri, 17 Jan 2014 08:51:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/5] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com> <1389518403-7715-2-git-send-email-qiaowei.ren@intel.com> <20140112092019.GA3664@pd.tnic> <52D35ABB.8070904@intel.com> <20140113103808.GC5388@pd.tnic> <9E0BE1322F2F2246BD820DA9FC397ADE014E575D@SHSMSX102.ccr.corp.intel.com> <20140117164736.GE8715@pd.tnic>
In-Reply-To: <20140117164736.GE8715@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 08:47 AM, Borislav Petkov wrote:
> 
> Right, so Steve and I played a couple of scenarios in IRC with this. So
> #BR is comparable with #PF, AFAICT, and as expected we don't take any
> locks when handling page faults in kernel space as we might deadlock.
> 
> Now, what happens if a thread is sleeping on some lock down that
> GFP_KERNEL allocation path and another thread gets a #BR and goes that
> same mmap_pgoff path and tries to grab that same lock?

It goes to sleep.  Same as if we take a page fault and have to page
something in.

> Also, what happens if you take a #BR in NMI context, say the NMI
> handler?

You should never, ever do that.  We should never take a #BR in the
kernel, full stop -- if we do it is panic time.

> All I'm trying to say is, it might not be such a good idea to sleep in a
> fault handler...

A fault handler from user space is really nothing other than a different
kind of system call.  It is nothing magic about it.

	-hpa

