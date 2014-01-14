Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaANBlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:41:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58862 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaANBlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:41:50 -0500
Message-ID: <52D495D1.5080505@hitachi.com>
Date: Tue, 14 Jan 2014 10:41:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
References: <20140113180400.GD5318@ghostprotocols.net> <20140113181458.GE5318@ghostprotocols.net>
In-Reply-To: <20140113181458.GE5318@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/14 3:14), Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 13, 2014 at 03:04:00PM -0300, Arnaldo Carvalho de Melo escreveu:
>> On a Ubuntu system just installed (13.10, x86_64), I'm installing the
>> devel libs one by one to check if there are problems with the automatic
>> disabling of features that requires libraries not installed.
>  
>> Stumbled at this:
>  
>> util/probe-event.c: At top level:
>> util/probe-event.c:193:12: error: ‘get_text_start_address’ defined but
>> not used [-Werror=unused-function]
> 
>> Investigating...
> 
> This patch below fixes it, applying.

Thank you for fixing it! It looks good for me.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>


> 
> Jiri, this is something else for the give-me-more-ponies list for
> tests/make: build it on freshly provisioned systems with multiple mixes
> of devel packages installed ;-)

I think we can change makefile to get some combinations of config options
when building perf tools.

Thank you,

> 
> - Arnaldo
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 86ed858..a4ee6b4 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -172,6 +172,7 @@ const char *kernel_get_module_path(const char *module)
>  	return (dso) ? dso->long_name : NULL;
>  }
>  
> +#ifdef HAVE_DWARF_SUPPORT
>  /* Copied from unwind.c */
>  static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  				    GElf_Shdr *shp, const char *name)
> @@ -217,6 +218,7 @@ out:
>  	elf_end(elf);
>  	return ret;
>  }
> +#endif
>  
>  static int init_user_exec(void)
>  {
> @@ -750,7 +752,8 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
>  
>  static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
>  				struct probe_trace_event **tevs __maybe_unused,
> -				int max_tevs __maybe_unused, const char *target)
> +				int max_tevs __maybe_unused,
> +				const char *target __maybe_unused)
>  {
>  	if (perf_probe_event_need_dwarf(pev)) {
>  		pr_warning("Debuginfo-analysis is not supported.\n");
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


