Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaAMHzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 02:55:25 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:54025 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaAMHzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 02:55:22 -0500
Date: Mon, 13 Jan 2014 09:55:18 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Subject: Re: [Linux-Xtensa] [PATCH v2] perf: add support for the xtensa
 architecture
Message-ID: <20140113075518.GH4944@tarshish>
References: <2681fd21a9ee014ffe77c0ec7304157be7209b6f.1388649430.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2681fd21a9ee014ffe77c0ec7304157be7209b6f.1388649430.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi perf maintainers,

Ping?

Anyone taking this for v3.14?

baruch

On Thu, Jan 02, 2014 at 09:57:10AM +0200, Baruch Siach wrote:
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v2: use the "core ID" field from /proc/cpuinfo (Max Filippov)
> ---
>  tools/perf/perf.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index b079304bd53d..e441864dbe03 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -132,6 +132,13 @@
>  #define CPUINFO_PROC	"CPU"
>  #endif
>  
> +#ifdef __xtensa__
> +#define mb()		asm volatile("memw" ::: "memory")
> +#define wmb()		asm volatile("memw" ::: "memory")
> +#define rmb()		asm volatile("" ::: "memory")
> +#define CPUINFO_PROC	"core ID"
> +#endif
> +
>  #define barrier() asm volatile ("" ::: "memory")
>  
>  #ifndef cpu_relax

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
