Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaFCCnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 22:43:31 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:37120 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaFCCn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 22:43:29 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Javi Merino <javi.merino@arm.com>
Subject: Re: [PATCH 4/4] tools lib traceevent: Added support for __get_bitmask() macro
References: <20140516140215.149535442@goodmis.org>
	<20140516140502.628373326@goodmis.org>
Date: Tue, 03 Jun 2014 11:43:26 +0900
In-Reply-To: <20140516140502.628373326@goodmis.org> (Steven Rostedt's message
	of "Fri, 16 May 2014 10:02:19 -0400")
Message-ID: <87iooiemr5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Fri, 16 May 2014 10:02:19 -0400, Steven Rostedt wrote:
> @@ -3691,6 +3784,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  	case PRINT_BSTRING:
>  		print_str_to_seq(s, format, len_arg, arg->string.string);
>  		break;
> +	case PRINT_BITMASK: {
> +		int bitmask_offset;
> +		int bitmask_size;
> +
> +		if (arg->bitmask.offset == -1) {
> +			struct format_field *f;
> +
> +			f = pevent_find_any_field(event, arg->bitmask.bitmask);
> +			arg->bitmask.offset = f->offset;
> +		}
> +		bitmask_offset = data2host4(pevent, data + arg->string.offset);

s/string.offset/bitmask.offset/

Thanks,
Namhyung


> +		bitmask_size = bitmask_offset >> 16;
> +		bitmask_offset &= 0xffff;
> +		print_bitmask_to_seq(pevent, s, format, len_arg,
> +				     data + bitmask_offset, bitmask_size);
> +		break;
> +	}
