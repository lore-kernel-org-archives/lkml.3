Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbaLVU17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:27:59 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:63103 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaLVU15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:27:57 -0500
MIME-Version: 1.0
In-Reply-To: <54987D4F.3000908@sr71.net>
References: <20141222200803.D316DA2A@viggo.jf.intel.com> <20141222200804.18A7A803@viggo.jf.intel.com>
 <CALCETrWAgPjLTA-iSabFmqVKiOKGPGgDgSWdjz3wsncs1X+WOg@mail.gmail.com> <54987D4F.3000908@sr71.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 12:27:36 -0800
Message-ID: <CALCETrXF11MeP8vc4eKqJz+2OOYQzmrK_erVEz=pZS3c=YWibw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, mpx: explicitly disable 32-bit MPX support on
 64-bit kernels
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:21 PM, Dave Hansen <dave@sr71.net> wrote:
> On 12/22/2014 12:17 PM, Andy Lutomirski wrote:
>>> >         /*
>>> > +        * 32-bit binaries on 64-bit kernels are currently
>>> > +        * unsupported.
>>> > +        */
>>> > +       if (IS_ENABLED(CONFIG_X86_64) && test_thread_flag(TIF_IA32))
>>> > +               return MPX_INVALID_BOUNDS_DIR;
>> Should this check mm->ia32_compat instead?
>
> set_personality_64bit/ia32() seem to make that and TIF_IA32 awfully
> equivalent.  Is there a specific reason for wanting it done this way?

My general desire to remove various bogus TIF_IA32 references.  But
this is only temporary, so I don't really care.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
