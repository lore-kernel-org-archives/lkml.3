Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbbAINP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:15:27 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:62518 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbbAINP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:15:26 -0500
Message-ID: <54AFD468.2020609@gmail.com>
Date: Fri, 09 Jan 2015 14:15:20 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>
CC: mtk.manpages@gmail.com, xmtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [patch] perf_event_open.2 clarify the PERF_FLAG_FD_* flags
References: <alpine.DEB.2.11.1501081201020.25399@vincent-weaver-1.umelst.maine.edu>
In-Reply-To: <alpine.DEB.2.11.1501081201020.25399@vincent-weaver-1.umelst.maine.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On 01/08/2015 06:04 PM, Vince Weaver wrote:
> 
> This change clarifies the behavior of the PERF_FLAG_FD_OUTPUT and
> PERF_FLAG_FD_NO_GROUP flags to perf_event_open(), and removes
> the related FIXME comments.

Patch applied. Thank you!

> While writing tests to validate the behavior of these flags I
> discovered that PERF_FLAG_FD_OUTPUT has been broken since the
> 2.6.35 kernel release.

Sigh!

Cheers,

Michael


> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/man2/perf_event_open.2 b/man2/perf_event_open.2
> index 8bde791..7181c29 100644
> --- a/man2/perf_event_open.2
> +++ b/man2/perf_event_open.2
> @@ -149,14 +149,17 @@ then
>  .BR execve (2).
>  .TP
>  .BR PERF_FLAG_FD_NO_GROUP
> -.\" FIXME . The following sentence is unclear
> -This flag allows creating an event as part of an event group but
> -having no group leader.
> -It is unclear why this is useful.
> -.\" FIXME . So, why is it useful?
> -.TP
> -.BR PERF_FLAG_FD_OUTPUT
> -This flag reroutes the output from an event to the group leader.
> +This flag tells the event to ignore the
> +.IR group_fd
> +parameter except for the purpose of setting up output redirection
> +using the
> +.B PERF_FLAG_FD_OUTPUT
> +flag.
> +.TP
> +.BR PERF_FLAG_FD_OUTPUT " (broken since Linux 2.6.35)."
> +This flag re-routes the event's sampled output to instead
> +be included in the mmap buffer of the event specified by
> +.IR group_fd .
>  .TP
>  .BR PERF_FLAG_PID_CGROUP " (since Linux 2.6.39)."
>  This flag activates per-container system-wide monitoring.
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
