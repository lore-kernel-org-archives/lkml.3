Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3KSRst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:48:49 -0500
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:34727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751624Ab3KSRsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:48:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:2:41:69:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2194:2196:2197:2198:2199:2200:2201:2202:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3291:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4117:4250:4321:4385:4605:4823:5007:6119:6238:7652:7903:9040:9592:10007:10848:11232:11233:11473:11658:11914:12043:12291:12295:12517:12519:12555:12679:12683:12740:13019:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: linen31_2f406c6651600
X-Filterd-Recvd-Size: 6548
Message-ID: <1384883323.17783.35.camel@joe-AO722>
Subject: Re: [PATCH] x86: boot: Fix mixed indentation in a20.c
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Johannes =?ISO-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Nov 2013 09:48:43 -0800
In-Reply-To: <20131119103408.GA3640@pd.tnic>
References: <1384797009-4096-1-git-send-email-johannes@kyriasis.com>
	 <528ACB6A.1040809@zytor.com> <20131119072241.GB32478@gmail.com>
	 <20131119103408.GA3640@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 11:34 +0100, Borislav Petkov wrote:
> On Tue, Nov 19, 2013 at 08:22:41AM +0100, Ingo Molnar wrote:
> > * H. Peter Anvin <hpa@zytor.com> wrote:
> > > On 11/18/2013 09:50 AM, Johannes Löthberg wrote:
> > > > Replace all mixed indentation with tabs
> > > > Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
> > > NAK.  Not worth the churn in the absence of other changes.
> > Yes.
> > If a20.c was cleaned up altogether, that might be a more tempting 
> > change, it has a good number of inconsistencies and improving it all 
> > would make it more readable.
> >  
> > But it makes little sense to do an incomplete cleanup.
> 
> Yeah, senseless cleanup without any benefit whatsoever (yeah, fuck
> readability! :-)) should be forbidden, if you ask me. Especially
> since it dilutes and muds up git history and finding the patch which
> introduced a change turns into a serious undertaking.

just fyi:

git diff -w and git blame -w both ignore whitespace changes
and can help in tracking down actual modifications.

If a20.c was to be modified for whatever reason, maybe this
below would be OK, but I too think it's not particularly
worthwhile as the file hasn't had or needed a significant
change in quite awhile.

This is sent as an example for Johannes, who it seems hasn't
ever submitted a patch before, more than to be applied.

Changes include:

o whitespace space->tab conversions
o spacing around arithmetic
o comment style neatening

Unsigned...

---

 arch/x86/boot/a20.c | 97 +++++++++++++++++++++++++++++------------------------
 1 file changed, 53 insertions(+), 44 deletions(-)

diff --git a/arch/x86/boot/a20.c b/arch/x86/boot/a20.c
index 64a31a6..e1dec7e 100644
--- a/arch/x86/boot/a20.c
+++ b/arch/x86/boot/a20.c
@@ -22,7 +22,7 @@ static int empty_8042(void)
 {
 	u8 status;
 	int loops = MAX_8042_LOOPS;
-	int ffs   = MAX_8042_FF;
+	int ffs = MAX_8042_FF;
 
 	while (loops--) {
 		io_delay();
@@ -46,17 +46,21 @@ static int empty_8042(void)
 	return -1;
 }
 
-/* Returns nonzero if the A20 line is enabled.  The memory address
-   used as a test is the int $0x80 vector, which should be safe. */
+/*
+ * Returns nonzero if the A20 line is enabled.
+ * The memory address used as a test is the int $0x80 vector,
+ * which should be safe.
+ */
 
-#define A20_TEST_ADDR	(4*0x80)
-#define A20_TEST_SHORT  32
-#define A20_TEST_LONG	2097152	/* 2^21 */
+#define A20_TEST_ADDR	(4 * 0x80)
+#define A20_TEST_SHORT	32
+#define A20_TEST_LONG	(1 << 21)	/* 2^21 = 2097152 */
 
 static int a20_test(int loops)
 {
 	int ok = 0;
-	int saved, ctr;
+	int saved;
+	int ctr;
 
 	set_fs(0x0000);
 	set_gs(0xffff);
@@ -66,7 +70,7 @@ static int a20_test(int loops)
 	while (loops--) {
 		wrfs32(++ctr, A20_TEST_ADDR);
 		io_delay();	/* Serialize and make delay constant */
-		ok = rdgs32(A20_TEST_ADDR+0x10) ^ ctr;
+		ok = rdgs32(A20_TEST_ADDR + 0x10) ^ ctr;
 		if (ok)
 			break;
 	}
@@ -81,8 +85,10 @@ static int a20_test_short(void)
 	return a20_test(A20_TEST_SHORT);
 }
 
-/* Longer test that actually waits for A20 to come on line; this
-   is useful when dealing with the KBC or other slow external circuitry. */
+/*
+ * Longer test that actually waits for A20 to come on line;
+ * this is useful when dealing with the KBC or other slow external circuitry.
+ */
 static int a20_test_long(void)
 {
 	return a20_test(A20_TEST_LONG);
@@ -116,7 +122,7 @@ static void enable_a20_fast(void)
 	u8 port_a;
 
 	port_a = inb(0x92);	/* Configuration port A */
-	port_a |=  0x02;	/* Enable A20 */
+	port_a |= 0x02;		/* Enable A20 */
 	port_a &= ~0x01;	/* Do not reset machine */
 	outb(port_a, 0x92);
 }
@@ -129,37 +135,40 @@ static void enable_a20_fast(void)
 
 int enable_a20(void)
 {
-       int loops = A20_ENABLE_LOOPS;
-       int kbc_err;
-
-       while (loops--) {
-	       /* First, check to see if A20 is already enabled
-		  (legacy free, etc.) */
-	       if (a20_test_short())
-		       return 0;
-	       
-	       /* Next, try the BIOS (INT 0x15, AX=0x2401) */
-	       enable_a20_bios();
-	       if (a20_test_short())
-		       return 0;
-	       
-	       /* Try enabling A20 through the keyboard controller */
-	       kbc_err = empty_8042();
-
-	       if (a20_test_short())
-		       return 0; /* BIOS worked, but with delayed reaction */
-	
-	       if (!kbc_err) {
-		       enable_a20_kbc();
-		       if (a20_test_long())
-			       return 0;
-	       }
-	       
-	       /* Finally, try enabling the "fast A20 gate" */
-	       enable_a20_fast();
-	       if (a20_test_long())
-		       return 0;
-       }
-       
-       return -1;
+	int loops = A20_ENABLE_LOOPS;
+
+	while (loops--) {
+		int kbc_err;
+
+		/*
+		 * First, check to see if A20 is already enabled
+		 * (legacy free, etc.)
+		 */
+		if (a20_test_short())
+			return 0;
+
+		/* Next, try the BIOS (INT 0x15, AX=0x2401) */
+		enable_a20_bios();
+		if (a20_test_short())
+			return 0;
+
+		/* Try enabling A20 through the keyboard controller */
+		kbc_err = empty_8042();
+
+		if (a20_test_short())
+			return 0; /* BIOS worked, but with delayed reaction */
+
+		if (!kbc_err) {
+			enable_a20_kbc();
+			if (a20_test_long())
+				return 0;
+		}
+
+		/* Finally, try enabling the "fast A20 gate" */
+		enable_a20_fast();
+		if (a20_test_long())
+			return 0;
+	}
+
+	return -1;
 }



