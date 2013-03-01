Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061Ab3CADGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:06:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3CADGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:06:33 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dCXt4Z_EDXgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VHl0eERhotoA:10 a=RxyK8sfA-hFjJdKiKSEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362107191.1231.25.camel@gandalf.local.home>
Subject: Re: linux-next: build failure after merge of the ftrace tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 Feb 2013 22:06:31 -0500
In-Reply-To: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 13:47 +1100, Stephen Rothwell wrote:
> Hi Steven,
> 
> After merging the ftrace tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> kernel/trace/trace_kdb.c: In function 'ftrace_dump_buf':
> kernel/trace/trace_kdb.c:29:33: error: invalid type argument of '->' (have 'struct trace_array_cpu')
> kernel/trace/trace_kdb.c:86:33: error: invalid type argument of '->' (have 'struct trace_array_cpu')
> 
> Caused by commit eaac1836c10e ("tracing: Replace the static global
> per_cpu arrays with allocated per_cpu").
> 
> I have used the ftrace tree from next-20130228 for today.

Thanks, I'll take a look into it. I also found that my latest push also
broke the ftrace snapshot feature. I'm currently bisecting what caused
that.

Hmm, interesting though, I thought it succeeded in building against an
allyesconfig?? Grumble, I'll have to run it through the tests again to
make sure I didn't screw something up, like test the wrong branch :-p

-- Steve


