Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3DXXIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:08:54 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:61496 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXXIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130423142546.GA17021@jshin-Toonie>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
	<1366703825-19373-2-git-send-email-jacob.shin@amd.com>
	<20130423131844.GA24467@redhat.com>
	<20130423142546.GA17021@jshin-Toonie>
Date: Thu, 25 Apr 2013 01:08:51 +0200
Message-ID: <CAFTL4hxpcuSVfk0dBm8RSL+iUZpQrbb51tU1-zPyFE=u2hhjXQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/4] perf: Add hardware breakpoint address mask
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/23 Jacob Shin <jacob.shin@amd.com>:
> From: Jacob Shin <jacob.shin@amd.com>
> Date: Mon, 22 Apr 2013 17:02:37 -0500
> Subject: [PATCH 1/4] perf: Add hardware breakpoint address mask
>
> Some architectures (for us, AMD Family 16h) allow for "don't care" bit
> mask to further qualify a hardware breakpoint address, in order to
> trap on range of addresses. Update perf uapi to add bp_addr_mask field.

It would be nice to describe a bit what this "don't care" bit mask is
about. Is it a range of address/bitmask to ignore in the middle of the
range we want to breakpoint in? I mean, that's confusing.

>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  include/uapi/linux/perf_event.h |    5 ++++-
>  kernel/events/hw_breakpoint.c   |    9 +++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index fb104e5..e22e1d1 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -286,7 +286,10 @@ struct perf_event_attr {
>                 __u64           config1; /* extension of config */
>         };
>         union {
> -               __u64           bp_len;
> +               struct {
> +                       __u32           bp_len;
> +                       __u32           bp_addr_mask;
> +               };

Do we need len and mask to work at the same time? I can't think of a
situation when len and mask mix up together in a useful way to define
a range.

Thanks.
