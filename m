Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3HGRdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:33:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3HGRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:33:09 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FLRpW3-vdtQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=dQA8RuyDQUMA:10 a=dPOkUoMoAfER8-GTxYwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375896786.6848.14.camel@gandalf.local.home>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Date: Wed, 07 Aug 2013 13:33:06 -0400
In-Reply-To: <20130807172044.GC18272@pd.tnic>
References: <20130807164934.149920591@goodmis.org>
	 <20130807165114.147890467@goodmis.org> <20130807172044.GC18272@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 19:20 +0200, Borislav Petkov wrote:
>   
> > +static void bug_at(unsigned char *ip, int line)
> > +{
> > +	/*
> > +	 * The location is not an op that we were expecting.
> > +	 * Something went wrong. Crash the box, as something could be
> > +	 * corrupting the kernel.
> > +	 */
> > +	pr_warning("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
> > +	       ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
> > +	BUG();
> 
> Why not simply
> 
> 	panic("Unexpected...")
> 
> ?

Because the patch replaced BUG().

> 
> Besides, BUG can be disabled in CONFIG_EXPERT.
> 

Right, and this code keeps the same logic as it was before. If it was
disabled by CONFIG_EXPERT, it stays disabled, but at least you get to
see a warning that your kernel may be corrupt now :-)

-- Steve


