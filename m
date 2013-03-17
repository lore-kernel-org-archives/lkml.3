Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab3CQXnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:43:01 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49222 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3CQXm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:42:58 -0400
Message-ID: <51465501.3080602@gmail.com>
Date: Sun, 17 Mar 2013 17:42:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: chenggang <chenggang.qin@gmail.com>
CC: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 3/8]Perf: Transform evlist->mmap to xyarray
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com> <1363167740-27735-6-git-send-email-chenggang.qin@gmail.com>
In-Reply-To: <1363167740-27735-6-git-send-email-chenggang.qin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/13 3:42 AM, chenggang wrote:
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index a2108ca..7f3f066 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -209,7 +209,8 @@ BASIC_CFLAGS = \
>   	-Iutil \
>   	-I. \
>   	-I$(TRACE_EVENT_DIR) \
> -	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
> +	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE \
> +	-std=gnu99

Why is this needed? at best it should be a separate patch just changing 
the Makefile.


>
>   BASIC_LDFLAGS =
>

Take my comments from your patch 1 of this version and apply here as 
well. e.g., in smaller patches introduce APIs to consolidate existing 
references. Once done change the implementation.


David
