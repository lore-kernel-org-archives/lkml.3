Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3CHBKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:10:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3CHBKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:10:50 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=0iPoHdVNtb4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=SgkOo2679A0A:10 a=VwQbUJbxAAAA:8 a=IeT0I4wo6r5chXZfExgA:9 a=CjuIK1q_8ugA:10 a=Gq9PjJF5URkA:10 a=U62fhAwekXMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Thu, 7 Mar 2013 20:10:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
Message-ID: <20130308011042.GE9161@home.goodmis.org>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
 <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
 <5138EF7F.1050003@windriver.com>
 <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
 <CAP=VYLpeqVOC2ZpCdnPDuLrRjwdpbHn3XQoSwAUaYFRdwQPfaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLpeqVOC2ZpCdnPDuLrRjwdpbHn3XQoSwAUaYFRdwQPfaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 07:49:35PM -0500, Paul Gortmaker wrote:
> 
> Within an hour, Fengguang's robots[1] found the branch, were compiling
> it for fringe architectures, and running sparse on it, and sending me the
> sparse regressions.  I'd listened to Fengguang's presentation while at
> KS in San Diego, but I had no idea it was this proactive, until it did
> autobot testing on my branch.

And people wonder why I wanted to give Fengguang a round of applauds
there. I guess I was one of the first people to get his testing, as it
found a lot of little things for me that my own tests missed.

> 
> I have most of the prebuilt toolchains[2], and two line wrappers to set
> the ARCH/CROSS_COMPILE, but as it stands, it seems I really don't
> need those any more.  I can sanity test on a common arch and then
> simply push to kernel.org to trigger build sanity across all arch.  I'll
> probably still continue to use the toolchain prebuilts to test locally
> though, just for the peace of mind.  But knowing FW bots are doing
> testing before it goes into linux-next or anywhere else is really nice.
> 

I should stress that there's a sample ktest.pl file for everyone:

 tools/testing/ktest/examples/crosstests.conf

Just download the cross compilers from:

 (assuming you're running on an x86_64 box)

  https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/

Install them somewhere like:

  /usr/local

ie.

  /usr/local/gcc-4.6.3-nolibc/mips-linux/bin/mips-linux-gcc

Have a pristine checkout, and a build directory to use:

 git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux.git
 mkdir cross-compile

Then just run:

  ktest.pl crosstests.conf

It will go arch by arch cross compiling each with the defconfig. Feel
free to modify that config. But really, there should be no more excuses
for kernel developers not doing cross compiles of most archs. It's
really that simple.

-- Steve

