Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3I3FIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 01:08:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50512 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3I3FIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 01:08:10 -0400
X-AuditID: 9c930179-b7c8bae000006c65-75-524907384661
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Fix to find line information for probe list
References: <20130927065707.17408.36033.stgit@udc4-manage.rcp.hitachi.co.jp>
Date: Mon, 30 Sep 2013 14:08:07 +0900
In-Reply-To: <20130927065707.17408.36033.stgit@udc4-manage.rcp.hitachi.co.jp>
	(Masami Hiramatsu's message of "Fri, 27 Sep 2013 15:57:07 +0900")
Message-ID: <87y56eoq14.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

Just a nitpick.

On Fri, 27 Sep 2013 15:57:07 +0900, Masami Hiramatsu wrote:
>  /**
> + * die_find_inlinefunc_next - Search an inlined function at given address
> + * @cu_die: a CU DIE which including @addr

s/cu_die/sp_die/

And it doesn't look like a CU DIE, anyway.


Thanks,
Namhyung


> + * @addr: target address
> + * @die_mem: a buffer for result DIE
> + *
> + * Search an inlined function DIE which includes @addr. Stores the
> + * DIE to @die_mem and returns it if found. Returns NULL if failed.
> + * Even if several inlined functions are expanded recursively, this
> + * doesn't trace it down, and returns the topmost one.
> + */
> +Dwarf_Die *die_find_inlinefunc_next(Dwarf_Die *sp_die, Dwarf_Addr addr,
> +				    Dwarf_Die *die_mem)
> +{
> +	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
> +}
