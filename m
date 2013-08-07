Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3HGApJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:45:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3HGApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:45:08 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=7f-O_72P7KBp29N_9koA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375836304.25420.76.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Tue, 06 Aug 2013 20:45:04 -0400
In-Reply-To: <1375821817.25420.50.camel@gandalf.local.home>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	 <1375725328.22073.101.camel@gandalf.local.home>
	 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <1375727977.22073.112.camel@gandalf.local.home>
	 <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
	 <1375798783.25420.30.camel@gandalf.local.home>
	 <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
	 <1375811885.25420.44.camel@gandalf.local.home>
	 <20130806203319.GA16170@Krystal>
	 <1375821817.25420.50.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 16:43 -0400, Steven Rostedt wrote:
> On Tue, 2013-08-06 at 16:33 -0400, Mathieu Desnoyers wrote:
> 
> > Steve, perhaps you could add a mode to your binary rewriting program
> > that counts the number of 2-byte vs 5-byte jumps found, and if possible
> > get a breakdown of those per subsystem ?
> 
> I actually started doing that, as I was curious to how many were being
> changed as well.

I didn't add it to the update program as that runs on each individual
object (needs to handle modules). But I put in the start up code a
counter to see what types were converted:

[    3.387362] short jumps: 106
[    3.390277]  long jumps: 330

Thus, approximately 25%. Not bad.

-- Steve


