Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335Ab3ICVP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:15:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760699Ab3ICVPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:15:24 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6vL9NhcTi7YA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Lu4-lkDicUYA:10 a=to-NsOc-1iq-6Jp2KtQA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 17:15:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 01/18 v2] ftrace: Add hash list to save RCU unsafe
 functions
Message-ID: <20130903171516.16290c47@gandalf.local.home>
In-Reply-To: <20130831051700.601365837@goodmis.org>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.601365837@goodmis.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 01:11:18 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a6d098c..3750360 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1356,6 +1356,23 @@ ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
>  static void
>  ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
>  
> +static int ftrace_convert_size_to_bits(int size)
> +{
> +	int bits;
> +
> +	/*
> +	 * Make the hash size about 1/2 the # found
> +	 */
> +	for (size /= 2; size; size >>= 1)
> +		bits++;
> +
> +	/* Don't allocate too much */
> +	if (bits > FTRACE_HASH_MAX_BITS)
> +		bits = FTRACE_HASH_MAX_BITS;
> +
> +	return bits;
> +}
> +


Just found this bug. Strange that gcc never gave me a warning :-/

-- Steve
