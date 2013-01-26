Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3AZVBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 16:01:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3AZVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 16:01:46 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XFXzPjxE9FUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Wg9lMJmbmcwA:10 a=gu6fZOg2AAAA:8 a=qvmll_tEmR6I0gQtaioA:9 a=PUjeQqilurYA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359234104.17639.2.camel@gandalf.local.home>
Subject: Re: [PATCH] mips: Move __virt_addr_valid() to a place for MIPS 64
From: Steven Rostedt <rostedt@goodmis.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Sat, 26 Jan 2013 16:01:44 -0500
In-Reply-To: <20130126201541.GF23053@blackmetal.musicnaut.iki.fi>
References: <1359137595.21576.246.camel@gandalf.local.home>
	 <20130126201541.GF23053@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-01-26 at 22:15 +0200, Aaro Koskinen wrote:
> Hi,
> 
> On Fri, Jan 25, 2013 at 01:13:15PM -0500, Steven Rostedt wrote:
> > Commit d3ce88431892 "MIPS: Fix modpost error in modules attepting to use
> > virt_addr_valid()" moved __virt_addr_valid() from a macro in a header
> > file to a function in ioremap.c. But ioremap.c is only compiled for MIPS
> > 32, and not for MIPS 64.
> > 
> > When compiling for my yeeloong2, which supposedly supports hibernation,
> > which compiles kernel/power/snapshot.c which calls virt_addr_valid(), I
> > got this error:
> 
> This has been reported also here:
> 
> 	http://marc.info/?l=linux-mips&m=135788867604856&w=2
> 
> and here:
> 
> 	http://marc.info/?l=linux-mips&m=135876719403187&w=2
> 

Hmm, interesting. Although, I prefer my change as it doesn't require
compiling all of ioremap.c where it's not needed.

> It's pretty sad that MIPS has been pretty much broken during the whole
> 3.8-rc cycle. :-(
> 

Yeah, that happens.

-- Steve

