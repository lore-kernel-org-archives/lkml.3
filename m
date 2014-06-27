Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaF0Lzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:55:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54876 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0Lzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:55:52 -0400
Date: Fri, 27 Jun 2014 13:55:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140627115545.GC23153@pd.tnic>
References: <20140625153227.GA13845@pd.tnic>
 <20140625202650.GC13845@pd.tnic>
 <20140627101831.GB23153@pd.tnic>
 <53AD586A.40900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53AD586A.40900@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 01:41:30PM +0200, Paolo Bonzini wrote:
> Il 27/06/2014 12:18, Borislav Petkov ha scritto:
> >Joerg says I should bisect but I'm busy with other stuff. If people are
> >interested in chasing this further, I could free up some time to do
> >so...
> 
> Please first try "-M pc-1.7" on the 2.0 QEMU.  If it fails, please do bisect
> it.  A QEMU bisection between one release only usually takes only half an
> hour or so for me.
> 
> I use
> 
> ../configure --target-list=x86_64-softmmu && make distclean &&
> ../configure --target-list=x86_64-softmmu &&
> make -j8 subdir-x86_64-softmmu
> 
> Until it's below 50 commits.  After that point just "make -j8
> subdir-x86_64-softmmu" should do.  This ensures that build system changes do
> not bite you as you move back and forth in time.

Ok, thanks for the help.

However, as it always happens, right after sending the mail, I triggered
it with the qemu installed on the system too :-( I.e., qemu 1.7.1.

So we will try to debug the #DF first to find out why kvm is injecting
it in the first place. I'll keep you posted.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
