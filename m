Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaJGRrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:47:33 -0400
Received: from p02c11o145.mxlogic.net ([208.65.144.78]:43520 "EHLO
	p02c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaJGRrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:47:32 -0400
X-MXL-Hash: 5434273450d86fda-0097295a1c322b4509110493ef735dc5adebba91
X-MXL-Hash: 543426bd112971eb-b38a62dc17af49a6d21291917840771cc58c3986
Date: Tue, 7 Oct 2014 13:45:28 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <paulmck@linux.vnet.ibm.com>
CC: Jiri Pirko <jiri@resnulli.us>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] workqueue: add quiescent state between work
 items
Message-ID: <20141007134528.1a59f31b@jlaw-desktop.mno.stratus.com>
In-Reply-To: <20141007134329.GA4880@linux.vnet.ibm.com>
References: <1412529862-17954-1-git-send-email-joe.lawrence@stratus.com>
	<1412529862-17954-2-git-send-email-joe.lawrence@stratus.com>
	<20141005192119.GE8549@htj.dyndns.org>
	<20141005194748.GG8549@htj.dyndns.org>
	<20141006042158.GW5015@linux.vnet.ibm.com>
	<20141007072942.GA2088@nanopsycho.orion>
	<20141007134329.GA4880@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=Qatyv6rv c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=_KQqW7t0BisA:10 a=BLc]
X-AnalysisOut: [eEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxI]
X-AnalysisOut: [AAAA:8 a=VnNF1IyMAAAA:8 a=oXe2fD9UkzWFrS56QJQA:9 a=CjuIK1q]
X-AnalysisOut: [_8ugA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014100712); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014 06:43:29 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Oct 07, 2014 at 09:29:42AM +0200, Jiri Pirko wrote:
[ ... snip ... ]
> > 
> > Paul, Tehun, how do you propose to fix this on older kernels which do
> > not have rcu_note_voluntary_context_switch? I'm particullary interested
> > in 3.10.
> 
> Hello, Jiri,
> 
> Older kernels can instead use rcu_note_context_switch().

Hi Paul,

Does 4a81e8328d37 ("rcu: Reduce overhead of cond_resched() checks for
RCU") affect a backport to 3.10?

I noticed that rcu_note_context_switch added a call to
rcu_momentary_dyntick_idle in that change, which is only present in
v3.16+.

Would rcu_note_context_switch be effective by itself on a 3.10 kernel?

Thanks,

-- Joe
