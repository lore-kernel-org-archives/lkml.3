Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbaLBQ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:58:45 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49367 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaLBQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:58:43 -0500
Date: Tue, 2 Dec 2014 08:58:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202165834.GJ25340@linux.vnet.ibm.com>
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
 <547D7B05.6080403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547D7B05.6080403@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120216-0013-0000-0000-000006B2D5F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 04:40:37PM +0800, Lai Jiangshan wrote:
> On 12/02/2014 03:14 AM, Paul E. McKenney wrote:
> > On Sun, Nov 30, 2014 at 11:02:43PM -0200, Dâniel Fraga wrote:
> >> On Sun, 30 Nov 2014 16:21:19 -0800
> >> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>
> >>> Maybe you'll have to turn off RCU_CPU_STALL_VERBOSE first.
> >>>
> >>> Although I think you should be able to just edit the .config file,
> >>> delete the like that says
> >>>
> >>>     CONFIG_TREE_PREEMPT_RCU=y
> >>>
> >>> and then just do a "make oldconfig", and then verify that
> >>> TREE_PREEMPT_RCU hasn't been re-enabled by some dependency. But it
> >>> shouldn't have, and that "make oldconfig" should get rid of anything
> >>> that depends on TREE_PREEMPT_RCU.
> >> 	
> >> 	Ok, I did exactly that, but CONFIG_TREE_PREEMPT_RCU is
> >> re-enabled. I talked with Pranith Kumar and he suggested I could just
> >> disable preemption (No Forced Preemption (Server)) and that's the only
> >> way to disable CONFIG_TREE_PREEMPT_RCU.
> > 
> > If it would help to have !CONFIG_TREE_PREEMPT_RCU with CONFIG_PREEMPT=y,
> 
> It is needed at lest for testing.
> 
> CONFIG_TREE_PREEMPT_RCU=y with CONFIG_PREEMPT=n is needed for testing too.
> 
> Please enable them (or enable them under CONFIG_RCU_TRACE=y)

It is a really easy edit to Kconfig, but I don't want people using it
in production because I really don't need the extra test scenarios.
So I am happy to provide the patch below as needed, but not willing to
submit it to mainline without a lot more justification.  Because if it
appears in mainline, people will start using it in production, whether
I am doing proper testing of it or not.  :-/

							Thanx, Paul

------------------------------------------------------------------------

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

