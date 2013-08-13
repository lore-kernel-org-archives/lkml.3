Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3HMXfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:35:21 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:33390 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3HMXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:35:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130813210228.989279359@goodmis.org>
References: <20130813210228.989279359@goodmis.org>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 13 Aug 2013 20:34:58 -0300
Message-ID: <CAKi4VALgK94oiv68x6XxEnwbYJcAhQDwgNoAT=KSGmuV01zR+g@mail.gmail.com>
Subject: Re: [PATCH 0/3] module: Allow parameters without arguments
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 6:02 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Rusty,
>
> I'm looking at porting my "enable tracepoints in module load" patches
> and one of the comments you gave me (long ago) was to not have:
>
>  trace_foo=1
>
> but to just have:
>
>  trace_foo
>
> as a parameter name. I went and implemented this but discovered that the
> functions that allow no arguments are hard coded in the params.c file.
>
> I changed this to allow other "set" functions to be given no arguments,
> and even noticed that a few already exist in the kernel. So I'm sending
> you this patch set that implements a modification to the parameter
> parsing to allow other kernel_param_ops to not bother with arguments
> passed in.
>
> What do you think?

so in kcmdline we would have modulename.param instead of modulename.param=1?

I guess we need to update kmod then, because currently we ignore and
treat this case as a wrong token. From a quick look, allowing it in
kmod would be as simple as removing a condition check.

Lucas De Marchi
