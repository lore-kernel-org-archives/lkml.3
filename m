Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaBWVpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:45:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbaBWVpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:45:39 -0500
Message-ID: <530A6BB4.2070407@zytor.com>
Date: Sun, 23 Feb 2014 13:44:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Feng Tang <feng.tang@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jacob Shin <jacob.shin@amd.com>,
        Jan Beulich <JBeulich@suse.com>,
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
Subject: Re: [PATCH v2 2/2] x86: Support compiling out human-friendly processor
 feature names
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org> <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org> <20140222204936.GA2534@pd.tnic> <20140222210038.GA19867@thin> <1b6550ce-40bd-4fc4-a3e4-37997da17973@email.android.com> <20140222213640.GA3409@thin> <530A3668.2090902@zytor.com> <20140223213252.GA14411@thin>
In-Reply-To: <20140223213252.GA14411@thin>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 01:32 PM, Josh Triplett wrote:
> 
> Because, in order to un-break the build, v3 wraps an ifdef around that
> dependency, to prevent building cpustr.h.  Otherwise, the rule for
> cpustr.h tries and fails to build mkcpustr.
> 

Why did it fail to build mkcpustr?  It would seem that mkcpustr is or at
least ought to be completely agnostic to any of these options.

The extra build machinery here seems completely pointless.

I agree that the #ifdef isn't a big deal, but all this extra machinery
really indicates something is odd.

Oh, and of course, looking at the v2 patchset, the problem is the ifdef
around the mkcapflags shell script which really shouldn't be necessary.
 We may have to add a rule to force capflags.c to be built even if
capflags.o is not requested, but that is fine.

That will cut down on the Makefile hacks considerably, and will avoid
this problem completely.

	-hpa

