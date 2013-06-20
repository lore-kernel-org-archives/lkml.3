Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3FTMOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:14:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16652 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3FTMOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:14:50 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EVMdXO81WbgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3fLAnx-yVNQA:10 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=xxu4z4-LsygLive_R0cA:9 a=QEXdDO2ut3YA:10 a=lcTMV_K9oDIA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371730487.18733.72.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/12] tracing: Add binary & filter for events
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 20 Jun 2013 08:14:47 -0400
In-Reply-To: <51C2B8AB.8060709@broadcom.com>
References: <20130620033516.003166252@goodmis.org>
	 <20130620033639.723900482@goodmis.org> <51C2B8AB.8060709@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 10:09 +0200, Arend van Spriel wrote:
> On 06/20/2013 05:35 AM, Steven Rostedt wrote:
> > By allowing a binary '&' operation, this gives the user the ability to
> > test a bit.
> >
> > Note, a binary '|' is not added, as it doesn't make sense as fields must
> > be compared to constants (for now), and ORing a constant will always return
> > true.
> >
> > Link:http://lkml.kernel.org/r/1371057385.9844.261.camel@gandalf.local.home
> >
> > Suggested-by: Arend van Spriel<arend@broadcom.com>
> 
> Actually, my attempt was triggered by the trace-cmd manual page:
> 
> "-f filter
> Specify a filter for the previous event. This must come after a -e. This 
> will filter what events get recorded based on the content of the event. 
> Filtering is passed to the kernel directly so what filtering is allowed 
> may depend on what version of the kernel you have. Basically, it will 
> let you use C notation to check if an event should be processed or not.
> 
> ==, >=, <=, >, <, &, |, && and ||
> 
> The above are usually safe to use to compare fields."

Ah thanks. That needs to be updated. Not sure why I wrote all of them.
Perhaps because the report side handles them and I just assumed the
kernel did too.

-- Steve

> 
> > Tested-by: Arend van Spriel<arend@broadcom.com>
> > Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> 
> Regards,
> Arend


