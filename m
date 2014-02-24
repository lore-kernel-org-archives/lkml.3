Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBXETF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 23:19:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57986 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaBXETD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 23:19:03 -0500
Message-ID: <530AC7E3.6050403@zytor.com>
Date: Sun, 23 Feb 2014 20:17:39 -0800
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
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org> <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org> <20140222204936.GA2534@pd.tnic> <20140222210038.GA19867@thin> <1b6550ce-40bd-4fc4-a3e4-37997da17973@email.android.com> <20140222213640.GA3409@thin> <530A3668.2090902@zytor.com> <20140223213252.GA14411@thin> <530A6BB4.2070407@zytor.com> <20140223215552.GB14411@thin>
In-Reply-To: <20140223215552.GB14411@thin>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 01:55 PM, Josh Triplett wrote:
> 
> Why have the build system waste time building several things that won't
> be used?  It seems like the Makefiles are exactly where we *should* have
> the ifdef machinery, rather than in source.  I'd happily add another
> ifdef in the Makefile rule that builds cpustr.h, to generate a stub
> cpustr.h header, and then remove one more ifdef in the source.
> 

The ifdeffery in the Makefiles really tend to be more complicated than
in the source code.  The amount of code added from v2 to v3 when it
could be handled by *removing* two lines in the Makefile makes it worth it.

If it was enough build stuff to be anywhere near remotely significant it
would be one thing.

	-hpa


