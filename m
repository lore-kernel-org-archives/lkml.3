Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3DBJ1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:27:07 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:61347 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab3DBJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:27:03 -0400
Message-ID: <1364894818.21627.90.camel@x61.thuisdomein>
Subject: Re: [PATCH 10/23] perf: make demangle support based on
 CONFIG_DEMANGLE
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 02 Apr 2013 11:26:58 +0200
In-Reply-To: <1364874877-5618-11-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
	 <1364874877-5618-11-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2013 09:26:58.0499 (UTC) FILETIME=[395E4130:01CE2F84]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 21:54 -0600, David Ahern wrote:
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 5c060c8..65283e6 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
>[...]
> @@ -571,7 +569,9 @@ ifdef CONFIG_LIBELF
>  	endif
>  else
>      NO_DWARF := 1
> -    NO_DEMANGLE := 1
> +    ifdef CONFIG_DEMANGLE
> +        $(error CONFIG_DEMANGLE depends on LIBELF)
> +    endif

You check for a dependency here ...

>      ifdef CONFIG_LIBUNWIND
>          $(error CONFIG_LIBUNWIND depends on LIBELF)
>      endif
>[...]
> diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
> index d6e067e..dc0fc36 100644
> --- a/tools/perf/Pconfig
> +++ b/tools/perf/Pconfig
> @@ -26,6 +26,10 @@ config LIBUNWIND
>      bool "Enable support for libunwind"
>      depends on HAVE_CFI_UNWIND_SUPPORT && LIBELF
>  
> + config DEMANGLE
> +    bool "Enable support for demangle"
> +    depends on LIBELF
> +

... that already seems to be enforced here.

>  config LIBPERL
>      bool "Enable support for perl scripting engine"
>  


Paul Bolle

