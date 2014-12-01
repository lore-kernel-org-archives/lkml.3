Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbaLAXIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:08:24 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42288 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbaLAXIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:08:19 -0500
Date: Mon, 1 Dec 2014 15:08:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141201230813.GE25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141126225745.GA30346@redhat.com>
 <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
 <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547ccf74.a5198c0a.25de.26d9@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120123-0005-0000-0000-000006C6564F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 06:28:31PM -0200, Dâniel Fraga wrote:
> On Mon, 1 Dec 2014 11:14:31 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > If it would help to have !CONFIG_TREE_PREEMPT_RCU with CONFIG_PREEMPT=y,
> > please let me know and I will create a patch that forces this.
> > (Not mainline material, but if it helps with debug...)
> 
> 	Hi Paul. Please, I'd like the patch, because without
> preemption, I'm unable to trigger this bug.

Well, this turned out to be way simpler than I expected.  Passes
light rcutorture testing.  Sometimes you get lucky...

							Thanx, Paul


diff --git a/init/Kconfig b/init/Kconfig
index 903505e66d1d..2cf71fcd514f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -469,7 +469,7 @@ choice
 
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
-	depends on !PREEMPT && SMP
+	depends on SMP
 	select IRQ_WORK
 	help
 	  This option selects the RCU implementation that is

