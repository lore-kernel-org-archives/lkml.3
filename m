Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaF2VUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 17:20:31 -0400
Received: from mout.gmx.net ([212.227.17.22]:55558 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaF2VU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 17:20:29 -0400
Message-ID: <53B08317.7010501@gmx.de>
Date: Sun, 29 Jun 2014 23:20:23 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFA][PATCH 20/27] parisc: ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140626165221.736847419@goodmis.org>	<20140626165852.497955187@goodmis.org> <20140626133548.03f7b90a@gandalf.local.home>
In-Reply-To: <20140626133548.03f7b90a@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:HNGHsM5k0sm53Rfz1E5Fcp1bsI9dzl3oyebT3Bg8HOg6mgMJvqI
 WcbBYywrAjQtF5OtQeRSl5J3KqjQmMvCKCskKOVBNzKhIoqw9KPeL04YrEV8wry0Aun3/ip
 JzAa4s8liSSQbX7L9xRBOl7UxFOilSEg9HbbguL5S2XnfP/zkmdxKuf58w+xL0mdzxSNICP
 SFBhA+/MXmKtwm6fLpxrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 06/26/2014 07:35 PM, Steven Rostedt wrote:
> On Thu, 26 Jun 2014 12:52:41 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> Nothing sets function_trace_stop to disable function tracing anymore.
>> Remove the check for it in the arch code.
> 
> From the cover letter, you were not Cc'd on.
> 
> Anyway, as there is no more reason to set function_trace_stop it is time
> to remove it. Unfortunately it's in several archs in assembly. Most of
> the assembly looks rather straight forward and I removed them myself.
> But I was only able to compile test them (for archs: arm64, metag, and
> microblaze I do not have my cross tools set up for them and did not
> even compile test it). But I would really love it if people can
> download their patch and test it out. You only need the patches that go
> against your arch and to really test it, also include the patch titled: 
> 
>  ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST
> 
> Otherwise your arch patch will call the list op that still does the
> check. That is, if you want to test suspend and resume on your arch.
> 
> As you may see, there are patches to the ftrace infrastructure that
> depend on the arch patches being implemented. I removed the
> functionality from the infrastructure, then removed it from the archs,
> and then finally removed the existence of the function_trace_stop
> variable, which would cause the archs to fail to compile if that were
> to go first.
> 
> If you can test your arch and give me your acked-by, I would appreciate
> it. Otherwise, if you need this to go through your tree, I would ask you
> to set up a dedicated branch that I can pull from to keep this order
> intact.

Sadly the arch-related tracing code in parisc is really broken.
It doesn't even compile cleanly on parisc (at least on 64bit), and as I wrote you in another mail
I really need to fix this soon (which I already started on).

But your patches look clean, so to get the basics right, I'm happy to give a 
Acked-by: Helge Deller <deller@gmx.de>
for the two patches which affect parisc, which are:
[PATCH 08/27] parisc: ftrace: Add call to ftrace_graph_is_dead() in function graph code
[PATCH 20/27] parisc: ftrace: Remove check of obsolete variable function_trace_stop

It would be good if you can push them through your tree.
I assume your tree is: 
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
with branch ftrace/next. 
Is this correct?
If yes, I can build my patches upon this tree...

Thanks!
Helge

