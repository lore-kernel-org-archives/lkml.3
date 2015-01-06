Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbbAFGpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:45:40 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46183 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbAFGph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:45:37 -0500
Message-ID: <54AB848E.2080808@gmail.com>
Date: Tue, 06 Jan 2015 07:45:34 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [patch] perf_event_open.2 exclude_host/exclude_guest clarification
References: <alpine.DEB.2.11.1412051027470.10310@vincent-weaver-1.umelst.maine.edu>
In-Reply-To: <alpine.DEB.2.11.1412051027470.10310@vincent-weaver-1.umelst.maine.edu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince et al,

On 12/05/2014 04:41 PM, Vince Weaver wrote:
> Hello
> 
> The PAPI developers recently ran into some issues with the various virtual 
> machine related settings in the perf_event_open() system call.
> 
> What follows is what my proposed updated manpage sections look like; I'm 
> hoping to get some sort of feedback about the correctness of these statements.

Vince, thanks for the proposed patches.

Does anyone have feedback about the correctness of Vince's proposed patches?

> 
> 	exclude_hv
> 		If this bit is set, the count excludes events that happen in 
> 		the hypervisor.  This is mainly for PMUs that have 
> 		built-in hardware support for this feature (such as POWER;
> 		this setting is silently ignored on x86). 
> 
> ...
> 
> 	exclude_host (since Linux 3.2)
> 		When  conducting  measurements that include processes 
> 		running VM instances (i.e. have executed a KVM_RUN 
> 		ioctl(2) ) only  measure events happening inside a guest 
> 		instance.  This is only meaningful outside the guests; 
> 		this setting does not change counts gathered inside of a 
> 		guest.  Currently this functionality is x86 only.
> 
> 	exclude_guest (since Linux 3.2)
> 		When conducting measurements that include processes 
> 		running VM instances  (i.e.  have executed a KVM_RUN 
> 		ioctl(2) ) do not measure events happening inside guest
> 		instances.  This is only meaningful outside the guests;  
> 		this setting does not change counts gathered inside of a 
> 		guest.  Currently this functionality is x86 only.
> 
> 
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
> 
> diff --git a/man2/perf_event_open.2 b/man2/perf_event_open.2
> index 638124c..a413c13 100644
> --- a/man2/perf_event_open.2
> +++ b/man2/perf_event_open.2
> @@ -833,10 +833,9 @@ If this bit is set, the count excludes events that happen in kernel-space.
>  .IR "exclude_hv"
>  If this bit is set, the count excludes events that happen in the
>  hypervisor.
> -This is mainly for PMUs that have built-in support for handling this
> -(such as POWER).
> -Extra support is needed for handling hypervisor measurements on most
> -machines.
> +This is mainly for PMUs that have built-in hardware support
> +for this feature (such as POWER; this setting is silently
> +ignored on x86).
>  .TP
>  .IR "exclude_idle"
>  If set, don't count when the CPU is idle.
> @@ -978,10 +977,24 @@ struct sample_id {
>  .fi
>  .TP
>  .IR "exclude_host" " (since Linux 3.2)"
> -Do not measure time spent in VM host.
> +When conducting measurements that include processes running
> +VM instances (i.e. have executed a
> +.I KVM_RUN
> +.BR ioctl (2)
> +) only measure events happening inside a guest instance.
> +This is only meaningful outside the guests; this setting does
> +not change counts gathered inside of a guest.
> +Currently this functionality is x86 only.
>  .TP
>  .IR "exclude_guest" " (since Linux 3.2)"
> -Do not measure time spent in VM guest.
> +When conducting measurements that include processes running
> +VM instances (i.e. have executed a
> +.I KVM_RUN
> +.BR ioctl (2)
> +) do not measure events happening inside guest instances.
> +This is only meaningful outside the guests; this setting does
> +not change counts gathered inside of a guest.
> +Currently this functionality is x86 only.
>  .TP
>  .IR "exclude_callchain_kernel" " (since Linux 3.7)"
>  Do not include kernel callchains.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
