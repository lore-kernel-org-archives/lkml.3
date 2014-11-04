Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaKDGdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:33:24 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57131 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKDGdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:33:21 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Pawel Moll <mail@pawelmoll.com>
Subject: Re: [PATCH v3 2/3] perf: Userspace event
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<1415060918-19954-3-git-send-email-pawel.moll@arm.com>
Date: Tue, 04 Nov 2014 15:33:19 +0900
In-Reply-To: <1415060918-19954-3-git-send-email-pawel.moll@arm.com> (Pawel
	Moll's message of "Tue, 4 Nov 2014 00:28:37 +0000")
Message-ID: <87ppd35vbk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Tue,  4 Nov 2014 00:28:37 +0000, Pawel Moll wrote:
> +	/*
> +	 * Data in userspace event record is transparent for the kernel
> +	 *
> +	 * Userspace perf tool code maintains a list of known types with
> +	 * reference implementations of parsers for the data field.
> +	 *
> +	 * Overall size of the record (including type and size fields)
> +	 * is always aligned to 8 bytes by adding padding after the data.
> +	 *
> +	 * struct {
> +	 *	struct perf_event_header	header;
> +	 *	u32				type;
> +	 *	u32				size;

The struct perf_event_header also has 'size' field and it has the entire
length of the record so it's redundant.  Also there's 'misc' field in the
perf_event_header and I guess it can be used as 'type' info as it's
mostly for cpumode and we are in user mode by definition.

Thanks,
Namhyung


> +	 *	char				data[size];
> +	 *	char				__padding[-size & 7];
> +	 * 	struct sample_id		sample_id;
> +	 * };
> +	 */
> +	PERF_RECORD_UEVENT			= 11,
> +
>  	PERF_RECORD_MAX,			/* non-ABI */
>  };
