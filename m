Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaLLVlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:41:11 -0500
Received: from www.sr71.net ([198.145.64.142]:54234 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbaLLVlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:41:10 -0500
Message-ID: <548B60F4.6020903@sr71.net>
Date: Fri, 12 Dec 2014 13:41:08 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit
 kernels
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net> <548B4FBE.5090101@sr71.net> <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com>
In-Reply-To: <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 12:48 PM, Andy Lutomirski wrote:
> On Fri, Dec 12, 2014 at 12:27 PM, Dave Hansen <dave@sr71.net> wrote:
>> You want the same size structures with the same format for 32-bit and
>> 64-bit modes?
> 
> Yes.  Especially because programs can switch between 32-bit and 64-bit
> mode entirely in userspace.  I don't know whether any do in practice,
> but programs *can*.

So, you want a 2GB of the 32-bit address space dedicated to a bounds
directory, and half of the space for the bounds tables to be simply
zero-filled unused address bits?  That seems, um, a bit unreasonable.

> Or better yet: Intel could have skipped supporting it at all in 32-bit
> mode.  

So, we should not have this security feature for 32-bit apps... because
it costs us 50 lines of code in the kernel to support?  Did you look at
the diffstat?

> Isn't mpx somewhat of an address space hog anyway?

Yes, it will be troublesome for 32-bit apps that are already bumping up
against the virtual address space size to support it.  But, really, how
many of those *are* there these days?
