Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161358AbaDPNwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:52:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36941 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161259AbaDPNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:52:04 -0400
Date: Wed, 16 Apr 2014 14:45:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 4/7] arm64: Add ftrace support
Message-ID: <20140416134506.GD1001@arm.com>
References: <1394705630-12384-1-git-send-email-takahiro.akashi@linaro.org>
 <1394862353-28963-5-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394862353-28963-5-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 05:45:50AM +0000, AKASHI Takahiro wrote:
> This patch implements arm64 specific part to support function tracers,
> such as function (CONFIG_FUNCTION_TRACER), function_graph
> (CONFIG_FUNCTION_GRAPH_TRACER) and function profiler
> (CONFIG_FUNCTION_PROFILER).
> 
> With 'function' tracer, all the functions in the kernel are traced with
> timestamps in ${sysfs}/tracing/trace. If function_graph tracer is
> specified, call graph is generated.
> 
> The kernel must be compiled with -pg option so that _mcount() is inserted
> at the beginning of functions. This function is called on every function's
> entry as long as tracing is enabled.
> In addition, function_graph tracer also needs to be able to probe function's
> exit. ftrace_graph_caller() & return_to_handler do this by faking link
> register's value to intercept function's return path.
> 
> More details on architecture specific requirements are described in
> Documentation/trace/ftrace-design.txt.
> 
> Reviewed-by: Ganapatrao Kulkarni <ganapatrao.kulkarni@cavium.com>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>

I'm still slightly suspicious about the alignment of your ASCII art, but:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
