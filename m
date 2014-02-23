Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaBWR6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 12:58:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaBWR6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 12:58:11 -0500
Message-ID: <530A3668.2090902@zytor.com>
Date: Sun, 23 Feb 2014 09:56:56 -0800
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
References: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org> <4bdaeab748d3b51ef24576ca030b5eb80455aff8.1393098813.git.josh@joshtriplett.org> <20140222204936.GA2534@pd.tnic> <20140222210038.GA19867@thin> <1b6550ce-40bd-4fc4-a3e4-37997da17973@email.android.com> <20140222213640.GA3409@thin>
In-Reply-To: <20140222213640.GA3409@thin>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 01:36 PM, Josh Triplett wrote:
> 
> No, even after removing the ifdefs around the build rules as you
> suggested (and v3's fixes for the resulting build issues, notably
> changing some -y's to -$(CONFIG_X86_FEATURE_NAMES)), the makefiles still
> manage to not build mkcpustr or cpustr.h, because nothing depends on it.
> 

How could it miss the rule:

$(obj)/cpu.o: $(obj)/cpustr.h

> I could change the build rules to generate an empty cpustr.h and avoid
> this ifdef, but that'd require an additional ifdef block in the Makefile.

Typically the way it is done is to generate the #ifdef *inside*
cpustr.h.  However, cpustr.h is kind of special anyway so it probably
doesn't matter.

	-hpa


