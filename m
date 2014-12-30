Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaL3WSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:18:53 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:50046 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaL3WSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:18:52 -0500
Message-ID: <54A324C5.4080605@hitachi.com>
Date: Wed, 31 Dec 2014 07:18:45 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: problems with perf probe and system libraries
References: <54A2285F.3040200@gmail.com>
In-Reply-To: <54A2285F.3040200@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

(2014/12/30 13:21), David Ahern wrote:
> Hi Masami:
> 
> I have been looking at perf-probe again and having a number of problems 
> with top of tree.
> 
> Here's the first one I have isolated:
> 
> $ perf probe -x /lib64/libc-2.18.so -a 'malloc  size=%di'
> Probe point 'malloc' not found.
>    Error: Failed to add events.

It seems to fail when failed to open debuginfo.
I confirmed it on ubuntu 14.04 too.
I'll try to fix that.

Thank you for reporting!

> 
> $ perf probe -x /lib64/libc-2.18.so -F | grep malloc
> malloc
> malloc@plt
> malloc_atfork
> malloc_check
> malloc_consolidate
> malloc_hook_ini
> malloc_info
> malloc_printerr
> mallochook
> ptmalloc_init
> ptmalloc_init.part.8
> ptmalloc_lock_all
> ptmalloc_unlock_all
> ptmalloc_unlock_all2
> tr_mallochook
> 
> $ perf probe -x /lib64/libc-2.18.so -a 'malloc=malloc size=%di'
> Probe point 'malloc' not found.
>    Error: Failed to add events.
> 
> A year ago (v3.12) this worked fine so I did a git bisect which points to:
> 
> commit fb7345bbf7fad9bf72ef63a19c707970b9685812
> Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Date:   Thu Dec 26 05:41:53 2013 +0000
> 
>      perf probe: Support basic dwarf-based operations on uprobe events
> 
> I have tried top of tree on Fedora 16, 18 and 20 with a variety of 
> kernels - and a variety of results. Reverting to 
> 8a613d40e389b723fd5889ac8d4033ed4030be31 which is the commit before this 
> one and it works again.
> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


