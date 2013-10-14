Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3JNNNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:13:46 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38471 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3JNNNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:13:44 -0400
Date: Mon, 14 Oct 2013 10:13:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V7 5/7] perf buildid-cache: add ability to add kcore to
 the cache
Message-ID: <20131014131335.GA11175@ghostprotocols.net>
References: <1381747424-3557-1-git-send-email-adrian.hunter@intel.com>
 <1381747424-3557-6-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381747424-3557-6-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 14, 2013 at 01:43:42PM +0300, Adrian Hunter escreveu:
> +static int kcore_copy__compare_fds(int from, int to)
<SNIP>
> +	while (1) {
> +		/* Use read because mmap won't work on proc files */
> +		ret = read(from, buf_from, page_size);
> +		if (ret < 0)
> +			return -1;
> +		if (!ret)
> +			return 0;
> +		n = ret;
> +		len = ret;
> +		while (n) {
> +			ret = read(to, buf_to, n);
> +			if (ret <= 0)
> +				return -1;
> +			n -= ret;

You can't go on potentially rewriting 'buf_to' like that, consider using
readn().

> +		}
> +
> +		if (memcmp(buf_from, buf_to, len))
> +			return -1;
> +	}
> +}
