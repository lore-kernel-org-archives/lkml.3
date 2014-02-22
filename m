Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaBVVTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 16:19:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43798 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaBVVTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 16:19:37 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140222210038.GA19867@thin>
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org> <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org> <20140222204936.GA2534@pd.tnic> <20140222210038.GA19867@thin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2 2/2] x86: Support compiling out human-friendly processor feature names
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 22 Feb 2014 13:18:14 -0800
To: Josh Triplett <josh@joshtriplett.org>, Borislav Petkov <bp@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>, Jan Beulich <JBeulich@suse.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Landley <rob@landley.net>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Message-ID: <1b6550ce-40bd-4fc4-a3e4-37997da17973@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On February 22, 2014 1:00:39 PM PST, Josh Triplett <josh@joshtriplett.org> wrote:
>On Sat, Feb 22, 2014 at 09:49:36PM +0100, Borislav Petkov wrote:
>> On Sat, Feb 22, 2014 at 11:57:10AM -0800, Josh Triplett wrote:
>> > diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
>> > index 6ec6bb6..29207f6 100644
>> > --- a/arch/x86/boot/cpu.c
>> > +++ b/arch/x86/boot/cpu.c
>> > @@ -16,7 +16,9 @@
>> >   */
>> >  
>> >  #include "boot.h"
>> > +#ifdef CONFIG_X86_FEATURE_NAMES
>> >  #include "cpustr.h"
>> > +#endif
>> 
>> You probably could get rid of this ifdef too by moving it into
>cpustr.h
>> after teaching arch/x86/boot/mkcpustr.c to issue it...
>
>That would require building and running mkcpustr, which doesn't happen
>when !CONFIG_X86_FEATURE_NAMES.  (And it'd require adding ifdefs to
>mkcpustr instead, which seems counterproductive.)
>

Didn't that change since v1?

>However, in exploring this, I ran into some build issues with v2 on a
>clean build; I'll send out v3 shortly with fixes to those.
>
>- Josh Triplett

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
