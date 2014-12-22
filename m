Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaLVUVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:21:39 -0500
Received: from www.sr71.net ([198.145.64.142]:58931 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbaLVUVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:21:38 -0500
Message-ID: <54987D4F.3000908@sr71.net>
Date: Mon, 22 Dec 2014 12:21:35 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 1/2] x86, mpx: explicitly disable 32-bit MPX support on
 64-bit kernels
References: <20141222200803.D316DA2A@viggo.jf.intel.com> <20141222200804.18A7A803@viggo.jf.intel.com> <CALCETrWAgPjLTA-iSabFmqVKiOKGPGgDgSWdjz3wsncs1X+WOg@mail.gmail.com>
In-Reply-To: <CALCETrWAgPjLTA-iSabFmqVKiOKGPGgDgSWdjz3wsncs1X+WOg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 12:17 PM, Andy Lutomirski wrote:
>> >         /*
>> > +        * 32-bit binaries on 64-bit kernels are currently
>> > +        * unsupported.
>> > +        */
>> > +       if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
>> > +               return MPX_INVALID_BOUNDS_DIR;
> Should this check mm->ia32_compat instead?

set_personality_64bit/ia32() seem to make that and TIF_IA32 awfully
equivalent.  Is there a specific reason for wanting it done this way?
