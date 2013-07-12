Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3GLCJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:09:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3GLCJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:09:10 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=c_B5fg8LQ7AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6K3jcYMAzPUA:10 a=5EvDNd7mrMAcO2Tz71wA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373594948.17876.77.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@akamai.com>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 22:09:08 -0400
In-Reply-To: <alpine.LNX.2.00.1307120027570.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
	 <51DF1B3C.8040603@linux.intel.com>
	 <alpine.LNX.2.00.1307120027570.29788@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 00:31 +0200, Jiri Kosina wrote:
> On Thu, 11 Jul 2013, H. Peter Anvin wrote:
> 
> > > synchronization after replacing "all but first" instructions should not
> > > be necessary (on Intel hardware), as the syncing after the subsequent
> > > patching of the first byte provides enough safety.
> > > But there's not only Intel HW out there, and we'd rather be on a safe
> > > side.
> > 
> > Has anyone talked to AMD or VIA about this at all?  Did anyone else ever
> > make SMP-capable x86?
> 
> If Boris can verify for AMD, that'd be good; we could then just remove one 
> extra syncing of the cores as a followup (can be done any time later, both 
> for alternative.c and ftrace in fact).
> 
> With the "extra" sync, the procedure is already verified to work properly 
> by ftace.
> 

I'd like to caution on the side of safety. The extra sync really doesn't
hurt. Let's keep it in for a kernel release cycle to make sure
everything else works properly, then we can look at optimizing it.

-- Steve


