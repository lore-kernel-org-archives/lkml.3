Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaGQCxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 22:53:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:51133 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaGQCxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 22:53:48 -0400
Message-ID: <53C73AB7.4080603@kernel.org>
Date: Wed, 16 Jul 2014 22:53:43 -0400
From: Sasha Levin <sashal@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>, Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, josh@joshtriplett.org,
        robh@kernel.org, florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch Feature Idea: Search directory for files with errors
 and warnings with -d argument
References: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>	<1405481937.14773.8.camel@joe-AO725>	<CAPDOMVhSosu-WZkBo+mKs3mJ+2+W-rBq0LFUnU_Lnzn=jR7=wg@mail.gmail.com>	<1405484621.14773.22.camel@joe-AO725>	<CAPDOMVi87FAukETbMbjtRqejgFN+mWfqZvP+Uw2eT===Oaz0ww@mail.gmail.com>	<1405485592.14773.29.camel@joe-AO725> <CAPDOMVgExn5i0ogz8dwtFgYXCPwGCpnt6Af_o-UOk-BUtFD9KA@mail.gmail.com>
In-Reply-To: <CAPDOMVgExn5i0ogz8dwtFgYXCPwGCpnt6Af_o-UOk-BUtFD9KA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 12:59 AM, Nick Krause wrote:
> On Wed, Jul 16, 2014 at 12:39 AM, Joe Perches <joe@perches.com> wrote:
>> > On Wed, 2014-07-16 at 00:28 -0400, Nick Krause wrote:
>>> >> I am cleaning up the kernel as it needs a lot of cleanup.
>> >
>> > Needs are curious things.
>> >
>> > Consistency is a nicety not really a need.
>> >
>> > Bugs need fixing.  Defects need eliminating.
>> > Enhancements are appreciated.  Inconsistent
>> > code style is a minor annoyance.
>> >
>> > I suggest you focus on the bugs, defects or
>> > enhancements in performance or testing.
>> >
>> > Are you really cross-compiling the patches you
>> > submit here or do you have an alpha on your desk?
>> >
>> >
> I am cross compiling then. I don't have the hardware :(.

Are you sure you're actually cross compiling them? From your
recent patchset it doesn't seem you even bother to do that:

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 174b7c6..886e469 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -23,7 +23,7 @@

 #include <asm/uaccess.h>

-#define memzero (s, n)	memset((s), 0 , (n))
+#define memzero { (s, n)	memset((s), 0 , (n)) }
 #define puts		srm_printk
 extern long srm_printk(const char *, ...)
 	__attribute__ ((format (printf, 1, 2)));
@@ -61,8 +61,8 @@ static unsigned outcnt;		/* bytes in output buffer */

 /* Diagnostic functions */
 #ifdef DEBUG
-#  define Assert (cond, msg) {if (!(cond)) error(msg) ; }
-#  define Trace(x) fprintf x
+#  define Assert { (cond, msg) {if (!(cond)) error(msg) ; } }
+#  define Trace { (x) fprintf x }
 #  define Tracev(x) {if (verbose) fprintf x ; }
 #  define Tracevv(x) {if (verbose > 1) fprintf x ; }
 #  define Tracec(c, x) {if (verbose && (c)) fprintf x ; }

Or:

diff --git a/arch/alpha/boot/misc.c b/arch/alpha/boot/misc.c
index 886e469..56c3325 100644
--- a/arch/alpha/boot/misc.c
+++ b/arch/alpha/boot/misc.c
@@ -144,7 +144,7 @@ static void error(char *x)
 	puts(x);
 	puts("\n\n -- System halted");

-	while (1);
+	while{ (1); }
 	/* Halt */
 }


Thanks,
Sasha
