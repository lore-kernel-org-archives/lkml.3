Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaBWVdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:33:11 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51373 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaBWVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:33:09 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 23 Feb 2014 13:32:52 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v2 2/2] x86: Support compiling out human-friendly
 processor feature names
Message-ID: <20140223213252.GA14411@thin>
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org>
 <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org>
 <20140222204936.GA2534@pd.tnic>
 <20140222210038.GA19867@thin>
 <1b6550ce-40bd-4fc4-a3e4-37997da17973@email.android.com>
 <20140222213640.GA3409@thin>
 <530A3668.2090902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530A3668.2090902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 09:56:56AM -0800, H. Peter Anvin wrote:
> On 02/22/2014 01:36 PM, Josh Triplett wrote:
> > 
> > No, even after removing the ifdefs around the build rules as you
> > suggested (and v3's fixes for the resulting build issues, notably
> > changing some -y's to -$(CONFIG_X86_FEATURE_NAMES)), the makefiles still
> > manage to not build mkcpustr or cpustr.h, because nothing depends on it.
> 
> How could it miss the rule:
> 
> $(obj)/cpu.o: $(obj)/cpustr.h

Because, in order to un-break the build, v3 wraps an ifdef around that
dependency, to prevent building cpustr.h.  Otherwise, the rule for
cpustr.h tries and fails to build mkcpustr.

> > I could change the build rules to generate an empty cpustr.h and avoid
> > this ifdef, but that'd require an additional ifdef block in the Makefile.
> 
> Typically the way it is done is to generate the #ifdef *inside*
> cpustr.h.  However, cpustr.h is kind of special anyway so it probably
> doesn't matter.

Given that only one file includes cpustr.h, and that seems unlikely to
ever change, moving the ifdef inside the header doesn't seem that
worthwhile.  If it were included more than once, it would definitely
make sense to generate a stub header.

- Josh Triplett
