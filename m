Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaF2OBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 10:01:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57112 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaF2OBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 10:01:07 -0400
Date: Sun, 29 Jun 2014 16:01:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Gleb Natapov <gleb@kernel.org>
Cc: Jan Kiszka <jan.kiszka@web.de>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140629140104.GB12528@pd.tnic>
References: <20140629064626.GD18167@minantech.com>
 <53AFE2B3.5080300@web.de>
 <20140629102403.GE18167@minantech.com>
 <53AFEB16.5040608@web.de>
 <20140629105339.GF18167@minantech.com>
 <53AFF192.7020801@web.de>
 <20140629115143.GA4362@pd.tnic>
 <53B0050B.90104@web.de>
 <20140629131443.GA5199@pd.tnic>
 <20140629134247.GG18167@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140629134247.GG18167@minantech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 04:42:47PM +0300, Gleb Natapov wrote:
> Please do so and let us know.

Yep, just did. Reverting ae9fedc793 fixes the issue.

> reinj:1 means that previous injection failed due to another #PF that
> happened during the event injection itself This may happen if GDT or fist
> instruction of a fault handler is not mapped by shadow pages, but here
> it says that the new page fault is at the same address as the previous
> one as if GDT is or #PF handler is mapped there. Strange. Especially
> since #DF is injected successfully, so GDT should be fine. May be wrong
> cpl makes svm crazy?

Well, I'm not going to even pretend to know kvm to know *when* we're
saving VMCB state but if we're saving the wrong CPL and then doing the
pagetable walk, I can very well imagine if the walker gets confused. One
possible issue could be U/S bit (bit 2) in the PTE bits which allows
access to supervisor pages only when CPL < 3. I.e., CPL has effect on
pagetable walk and a wrong CPL level could break it.

All a conjecture though...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
