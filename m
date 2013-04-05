Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161475Ab3DEIVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 04:21:02 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42311 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3DEIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 04:20:59 -0400
Message-ID: <515E8968.9070506@hitachi.com>
Date: Fri, 05 Apr 2013 17:20:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, OSDepend <osdepend@gmail.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] perf probe: Enhance error message on non-kprobeable
 functions
References: <1365129545-11689-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1365129545-11689-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/05 11:39), Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Some of kernel functions are not allowed to be used by kprobes for
> some reason, so they're marked as __kprobe on the source code and
> reside on ".kprobes.text" section.
> 
> However normal users which only see /proc/kallsyms don't know about
> them and would get only general error message when tried to add a
> probe on such function.

Right,

> 
>   $ sudo ./perf probe do_page_fault
>   Failed to find path of kernel module.
>   Added new event:
>   Failed to write event: Invalid argument
>     Error: Failed to add events. (-1)
> 
> This patch enhance it by checking the special kprobes section address
> and if to-be-probed function address is in the section, it would print
> like this:
> 
>   $ sudo ./perf probe do_page_fault
>   Failed to find path of kernel module.
>   Added new event:
>   Failed to write event: kprobes is not allowed for this function.
>     Error: Failed to add events. (-1)

Yeah, I agree that it is hard to know for perf probe users.
However, your implementation strongly depends on the current kernel,
I think we'd better export __kprobe_text_* as macros of symbol strings
in kprobes.h, and reuse it.
Or, export such no-probe symbols via /sys/kernel/debug/kprobes/noprobe_syms

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


