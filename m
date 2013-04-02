Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332Ab3DBJcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:32:09 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:56182 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760536Ab3DBJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:32:05 -0400
Message-ID: <1364895122.21627.94.camel@x61.thuisdomein>
Subject: Re: [PATCH 09/23] perf: make cfi unwind support based on
 CONFIG_LIBUNWIND
From: Paul Bolle <pebolle@tiscali.nl>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 02 Apr 2013 11:32:02 +0200
In-Reply-To: <1364874877-5618-10-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
	 <1364874877-5618-10-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2013 09:32:02.0689 (UTC) FILETIME=[EEADF710:01CE2F84]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 21:54 -0600, David Ahern wrote:
> --- a/tools/perf/Pconfig
> +++ b/tools/perf/Pconfig
> @@ -1,3 +1,14 @@
> +config ARCH
> +    string
> +    option env="ARCH"

Why does this copy init/Kconfig?

> +config X86
> +    def_bool y if ARCH = "x86"
> +    select HAVE_CFI_UNWIND_SUPPORT
> +

Doesn't this clash with the same Kconfig symbol in arch/x86/Kconfig?

> +config HAVE_CFI_UNWIND_SUPPORT
> +    bool
> +
>  config NEWT
>      bool "Enable newt-based TUI"
>  


Paul Bolle

