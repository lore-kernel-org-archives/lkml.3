Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbbAMUoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:44:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbbAMUoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:44:02 -0500
Message-ID: <54B58382.9030908@redhat.com>
Date: Tue, 13 Jan 2015 15:43:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 06/11] x86,fpu: lazily skip fpu restore with eager
 fpu mode, too
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-7-git-send-email-riel@redhat.com> <CALCETrWWLzdPrmGdw7+g68Sy2m9Fs6U5nO3dWAOHt8XAxXSb3g@mail.gmail.com>
In-Reply-To: <CALCETrWWLzdPrmGdw7+g68Sy2m9Fs6U5nO3dWAOHt8XAxXSb3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 12:11 PM, Andy Lutomirski wrote:
> On Sun, Jan 11, 2015 at 1:46 PM,  <riel@redhat.com> wrote:

>> diff --git a/arch/x86/include/asm/fpu-internal.h
>> b/arch/x86/include/asm/fpu-internal.h index 4db8781..a5a40c7
>> 100644 --- a/arch/x86/include/asm/fpu-internal.h +++
>> b/arch/x86/include/asm/fpu-internal.h @@ -435,13 +435,9 @@ static
>> inline void switch_fpu_prepare(struct task_struct *old, struct
>> task_struc old->thread.fpu.last_cpu = ~0; if (preload) { 
>> new->thread.fpu_counter++; -                       if
>> (!use_eager_fpu() && fpu_lazy_restore(new, cpu)) -
>> /* XXX: is this safe against ptrace??? */ -
>> __thread_fpu_begin(new); -                       else { +
>> set_thread_flag(TIF_LOAD_FPU); +                       if
>> (!fpu_lazy_restore(new, cpu)) prefetch(new->thread.fpu.state);
> 
> Is this prefetch still worth keeping?  Wouldn't prefetching the
> fpu effectively require grabbing more than one cacheline anyway?

Probably not. I'll drop it, for more code simplification.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtYOCAAoJEM553pKExN6DDYMIAL3m7Nmlz8qiYrDEIhimHupj
JeIp92cdm+AcgeYydC9Tzz3cQrDExjJ3juI25OmjYF1rTHoRyFC/trWCjUajeKxa
rdxyHYmcNCvsmvEN9Ls3IfrRt4SF7iDKP9P9Qa49rakCprR82P2UUQ25zDuad8wR
n7G+nev1GNpsc8w8++ebczyEgVq579s2QA3x/mpO9FWA2DNrSndT1P7OxY6BBbEO
jcp/9V17rfZOvh7W9yCSRs9M5B3OzjACTktSTRWWuPHS7qBJa1/oeA7Z45Vgb9Bk
xxH1zS4IPcHu5WEB4FTDPYHoR7NOPWaXNDViU3NnV6jMzaCff1Vd6XgN5PHQhZc=
=y0qh
-----END PGP SIGNATURE-----
