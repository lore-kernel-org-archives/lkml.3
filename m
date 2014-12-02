Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbaLBUsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:48:23 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37692 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaLBUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:48:20 -0500
Date: Tue, 2 Dec 2014 12:48:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202204812.GP25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141202203044.GA26482@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141202203044.GA26482@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120220-0025-0000-0000-000006915856
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 03:30:44PM -0500, Dave Jones wrote:
> On Mon, Dec 01, 2014 at 12:36:34PM -0800, Linus Torvalds wrote:
>  > On Mon, Dec 1, 2014 at 12:28 PM, Dâniel Fraga <fragabr@gmail.com> wrote:
>  > >
>  > >         Hi Paul. Please, I'd like the patch, because without
>  > > preemption, I'm unable to trigger this bug.
>  > 
>  > Ok, that's already interesting information. And yes, it would probably
>  > be interesting to see if CONFIG_PREEMPT=y but !CONFIG_TREE_PREEMPT_RCU
>  > then solves it too, to narrow it down to one but not the other..
> 
> That combination doesn't seem possible. TREE_PREEMPT_RCU is the only
> possible choice if PREEMPT=y

Indeed, getting that combination requires a Kconfig patch, which I
supplied below.  Not for mainline, debugging only.

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

