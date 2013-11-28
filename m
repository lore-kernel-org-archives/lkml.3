Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab3K1QDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:03:51 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58310 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3K1QDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:03:49 -0500
Message-ID: <52976961.2010609@gmail.com>
Date: Thu, 28 Nov 2013 09:03:45 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv3 3/7] perf tools: Fine tune readn function
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com> <1385634619-8129-4-git-send-email-jolsa@redhat.com> <52975F17.2050402@gmail.com> <20131128154350.GB31444@krava.brq.redhat.com>
In-Reply-To: <20131128154350.GB31444@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 8:43 AM, Jiri Olsa wrote:

> -		if (ret <= 0)
> +		if ((ret <= 0) && (errno != EINTR))
>   			return ret;

I think you want:
if (ret < 0 && errno == EINTR)
	continue;

if (ret <= 0)
	return ret;

You certainly do not want ret < 0 here: ;-)

>
> -		n -= ret;
> -		buf += ret;
> +		left -= ret;
> +		buf  += ret;
>   	}
>
> -	return buf - buf_start;
> +	BUG_ON((size_t)(buf - buf_start) != n);
> +	return n;
>   }
>
>   size_t hex_width(u64 v)
>

