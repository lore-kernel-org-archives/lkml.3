Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab3DZJBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:01:38 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:37645 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab3DZJBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:01:35 -0400
Message-ID: <517A426C.6020701@intel.com>
Date: Fri, 26 Apr 2013 10:01:32 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 fixes for 3.9
References: <201304252144.r3PLihDe025383@terminus.zytor.com> <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com> <1366928604.9976.3.camel@x230> <20130426072919.GA31557@gmail.com>
In-Reply-To: <20130426072919.GA31557@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 08:29, Ingo Molnar wrote:
> I'm worried about the fragility of this code - this is firmware code ...
> 
> I think firmware code should be fundamentally paranoid and robust, and in 
> this case treat all EFI-provided data as hostile and do a much sanity 
> checking of it as possible - and provide an actionable error message if 
> the checks fail, not just 'crash'.
> 
> Even if no-one complained, yet.

I'm not sure how much more robust checking for NULL makes it, it's not
going to save us from garbage pointers, etc. Instead of the pointer
being NULL a more likely bug is that query_variable_info() exists (for
those firmware that implement the relevant spec version), but doesn't
work correctly. That's the kind of bug we've been seeing in other
functions.

To be fair to Josh, his original submission did include the NULL check,
but I asked him to remove it. If someone really wants to re-add the
check for a NULL pointer, I'm not super opposed to it.
