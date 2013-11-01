Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3KASKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:10:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51072 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3KASKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:10:23 -0400
From: Michael Hudson-Doyle <michael.hudson@linaro.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH v2] perf tools: Remove cast of non-variadic function to variadic
In-Reply-To: <20131101133626.GA6409@infradead.org>
References: <87zjppvw7y.fsf@canonical.com> <20131101133626.GA6409@infradead.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/24.3.50.2 (x86_64-pc-linux-gnu)
Date: Fri, 01 Nov 2013 11:10:16 -0700
Message-ID: <87wqksvvqv.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme@redhat.com> writes:

> Em Thu, Oct 31, 2013 at 04:47:45PM -0700, Michael Hudson-Doyle escreveu:
>> -int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent)
>> +int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
>>  {
>> -	const char *color = get_percent_color(percent);
>> +	va_list args;
>> +	double percent;
>> +	const char *color;
>> +
>> +	va_start(args, fmt);
>> +	percent = va_arg(args, double);
>> +	va_end(args);
>> +	color = get_percent_color(percent);
>>  	return color_snprintf(bf, size, color, fmt, percent);
>>  }
>
> As a bug fix I'm merging this now, but I wonder if, since we're doing
> the va_start/end dance here, can't we call some color_vsnprintf variant
> so as to avoid doing it twice?

I thought that, but we need to get the percent argument anyway.  I
couldn't decide if it was better to call color_vsnprintf with args or
color_snprintf with percent so I went for the laziest option / minimal
diff.  Can clearly write a patch for the alternative if you like...

> I'll look into that after going thru more urgent stuff.

Thanks!

Cheers,
mwh
