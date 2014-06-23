Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaFWXm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:42:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:64635 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaFWXmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:42:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,533,1400050800"; 
   d="scan'208";a="562162356"
Message-ID: <53A8BB5A.5090103@intel.com>
Date: Mon, 23 Jun 2014 16:42:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v6 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com> <53A8874A.3050301@mit.edu> <53A88966.5080400@intel.com> <CALCETrX7B8yxrNgojCR8YNH+6zHX8vq+GMFn0RjdWXdLmhA-Fg@mail.gmail.com>
In-Reply-To: <CALCETrX7B8yxrNgojCR8YNH+6zHX8vq+GMFn0RjdWXdLmhA-Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 03:00 PM, Andy Lutomirski wrote:
> Hmm.  How about PR_SET/GET_MPX_BOUNDS_TABLE, to update the kernel's
> copy.  No fpu magic needed.
> 
> This has an added benefit: CRIU will need updating for MPX, and
> they'll appreciate having the required interface already exist.
> (They'll want a way to allocate "MPX" memory, too, but that's probably
> somewhat less important, and it won't result in duplicated
> functionality.)

I like the idea of the most minimal interface possible.  If the kernel
ever needed or wanted to cache more of the register setup, we wouldn't
need to change the interface.  For CRIU, I don't know much about the
phases of how it sets itself up, but I guess the difference would be
whether userspace has to do a register save and restore and a prctl() or
just a plain prctl() with extra arguments.  Doesn't seem fundamentally
different to me.

BTW, it's not a pointer to a bounds table, it's the bounds directory.
There are two levels of the tables.
