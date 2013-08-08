Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab3HHMPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:15:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3HHMPR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:15:17 -0400
Message-ID: <1375964098.18565.54.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>,
        Youquan Song <youquan.song@intel.com>, LenBrown <len.brown@intel.com>
Date: Thu, 08 Aug 2013 14:14:58 +0200
In-Reply-To: <260513AB-5C95-49F1-B437-91039CD8CD26@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
	 <1375775172.5412.14.camel@marge.simpson.net>
	 <BD6ACAD8-25D7-406B-A843-22696F9D8DCC@gmail.com>
	 <260513AB-5C95-49F1-B437-91039CD8CD26@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:1//hZ7DnPYzRHS9vM8DV4OnEtAz6laTt1Vb/Qhkg00g
 whfv3sZ360wHn2VXD2dm5VfhKaR1AgXnGw6VJ9ZdXXAagrUNkC
 Mdms4gqaBqw8DAtM4YB3YfcB2haaw0BBozW4Zluk38S7Olu8bO
 lgvm76e+vZgPmdC5CSFy0EOHQj/hLipFd6qEW2NClwRO5ScDXD
 LtfpA+UCK0F/R1MlnxpyQe1SDw+IMC/SFlFyEeEbmNk0q9FU95
 1RiT/ujYPBGa5RBSg0xMOwBY9lFxlIiynQl/LK3UGCk3VErI2C
 uSZqPMfn6+FmoFXD5cgCSlhdqX+S5LaWLCjAZVFvUxnvmvu8VG
 ALBX/F2/edhHmAcUy3xlrB8hr1C5/cQsJRDony7+h7C8Qbp6Gg
 xCLay1q1/jqLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 17:04 +0800, ethan.zhao wrote:

> So, it's Peter's patch working………

Yes.  My patch killed the nohz tick start/stop overhead prior to 3.8,
but in 3.8, the menu governor changes added more high frequency timer
banging that negated its effect.  In 3.9, mwait went away, making core2
boxen very sad, and in 3.10 all of x86 got generic idle, making my boxen
even sadder.

select_idle_sibling() (the thing that makes us schedule pipe-test and
many other things cross core if there's an idle core available) has
always been two-faced, doing both good and evil.. but with recent work,
it's leaning more toward evil than ever before.

-Mike

