Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaDRHvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 03:51:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62249 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaDRHvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:51:53 -0400
Date: Fri, 18 Apr 2014 09:51:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 0/3] perf tools: Speedup DWARF unwind
Message-ID: <20140418075148.GA13793@gmail.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> hi,
> trying to speedup DWARF unwind report code by factoring
> related code:
>   - caching sample's registers access
>   - keep dso data file descriptor open for the
>     life of the dso object
>   - replace dso cache code by mapping dso data file
>     directly for the life of the dso object
> 
> The speedup is mainly for libunwind unwind. The libdw will benefit
> mainly from cached registers access, because it handles dso data
> accesses by itself.. and anyway it's still faster ;-).

Just curious: do you have any numbers about how much faster it got in 
practice?

Thanks,

	Ingo
