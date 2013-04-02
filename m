Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373Ab3DBJh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:37:29 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:50408 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761354Ab3DBJh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:37:26 -0400
Message-ID: <1364895445.21627.98.camel@x61.thuisdomein>
Subject: Re: [PATCH 20/23] perf: consolidate CONFIG_LIBELF checks in Makefile
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 02 Apr 2013 11:37:25 +0200
In-Reply-To: <1364874877-5618-21-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
	 <1364874877-5618-21-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2013 09:37:25.0792 (UTC) FILETIME=[AF439200:01CE2F85]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 21:54 -0600, David Ahern wrote:
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
>[...]
> @@ -602,6 +590,16 @@ ifdef CONFIG_LIBELF
>      endif
>  
>  else
> +    ifdef CONFIG_DWARF
> +        $(error CONFIG_DWARF depends on LIBELF)
> +    endif
> +    ifdef CONFIG_DEMANGLE
> +        $(error CONFIG_DEMANGLE depends on LIBELF)
> +    endif
> +    ifdef CONFIG_LIBUNWIND
> +        $(error CONFIG_LIBUNWIND depends on LIBELF)
> +    endif
> +
>      EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
>  
>      # Remove ELF/DWARF dependent codes

A quick scan of your series suggests you check here for dependencies
that are already enforced by the kconfig tools. Why is this needed?


Paul Bolle

