Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaD0Ogn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:36:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60856 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaD0Ogl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:36:41 -0400
Subject: Re: [PATCH 2/3] perf tools: Cache dso data file descriptor
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>
In-Reply-To: <1397756352-26694-3-git-send-email-jolsa@redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
	 <1397756352-26694-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Apr 2014 23:36:35 +0900
Message-ID: <1398609395.1689.17.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-17 (목), 19:39 +0200, Jiri Olsa:
> Keeping the data file description open for the whole life
> of the dso object.

I suspect there might be an issue for reporting very large data file
with this approach - like open file limit?


[SNIP]
> @@ -168,8 +174,8 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
>  	};
>  	int i = 0;
>  
> -	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND)
> -		return open_dso(dso, machine);

Why did you remove this line?

Thanks,
Namhyung


> +	if (dso->data_fd >= 0)
> +		return dso->data_fd;
>  
>  	do {
>  		int fd;
> @@ -178,7 +184,7 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
>  
>  		fd = open_dso(dso, machine);
>  		if (fd >= 0)
> -			return fd;
> +			return dso->data_fd = fd;
>  
>  	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);


