Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936044Ab3DIPH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:07:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934973Ab3DIPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:07:27 -0400
X-Authority-Analysis: v=2.0 cv=Pu4Rnnw3 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6YC5YRaTPZoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=7doBReAiqyEA:10 a=dFVzn5v-dOgFv5HfUkgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1365520045.25498.62.camel@gandalf.local.home>
Subject: Re: [PATCH 4/4] uprobes/tracing: generalize struct
 uprobe_trace_entry_head
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Tue, 09 Apr 2013 11:07:25 -0400
In-Reply-To: <20130409145054.GA22913@redhat.com>
References: <20130329181548.GA20700@redhat.com>
	 <1365436535.25498.12.camel@gandalf.local.home>
	 <20130409145054.GA22913@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 16:50 +0200, Oleg Nesterov wrote:
> On 04/08, Steven Rostedt wrote:

> OK, will do.
> 
> Or. Instead of enum we can use "bool is_return". So, instead of
> 
> 	if (is_ret_probe(tu))
> 		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_RETPROBE);
> 	else
> 		size = SIZEOF_TRACE_ENTRY(UPROBE_ENTRY_NORMAL);
> 
> we can do
> 
> 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
> 
> What do you like more?

Which ever is easier ;-)

I just hated the magic "1" and "2". As long as I (or any reviewer) does
not need to go searching for numbers, and can easily figure out what is
going on by looking at the code at hand, I'm happy.

Both the above satisfy that requirement.

Your "is_ret_probe(tu)" may have the added bonus of being less error
prone.

Thanks,

-- Steve


