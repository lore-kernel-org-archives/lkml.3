Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab3K1PT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:19:56 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36127 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab3K1PTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:19:54 -0500
Message-ID: <52975F17.2050402@gmail.com>
Date: Thu, 28 Nov 2013 08:19:51 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/7] perf tools: Fine tune readn function
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com> <1385634619-8129-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/13, 3:30 AM, Jiri Olsa wrote:
> @@ -151,21 +152,26 @@ unsigned long convert_unit(unsigned long value, char *unit)
>   	return value;
>   }
>
> +/*
> + * Read exactly 'n' bytes or return an error.
> + */
>   ssize_t readn(int fd, void *buf, size_t n)
>   {
>   	void *buf_start = buf;
> +	size_t left = n;
>
> -	while (n) {
> -		ssize_t ret = read(fd, buf, n);
> +	while (left) {
> +		ssize_t ret = read(fd, buf, left);
>
>   		if (ret <= 0)
>   			return ret;

handle EINTR errors? no need to fail readn if the system call is 
interrupted.

David
