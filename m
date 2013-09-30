Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab3I3Fcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 01:32:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48144 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3I3Fcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 01:32:50 -0400
Message-ID: <52490CFE.6030409@hitachi.com>
Date: Mon, 30 Sep 2013 14:32:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Re: [PATCH -tip ] [BUGFIX] perf probe: Fix to find line information
 for probe list
References: <20130927065707.17408.36033.stgit@udc4-manage.rcp.hitachi.co.jp> <87y56eoq14.fsf@sejong.aot.lge.com>
In-Reply-To: <87y56eoq14.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/30 14:08), Namhyung Kim wrote:
> Hi Masami,
> 
> Just a nitpick.
> 
> On Fri, 27 Sep 2013 15:57:07 +0900, Masami Hiramatsu wrote:
>>  /**
>> + * die_find_inlinefunc_next - Search an inlined function at given address
>> + * @cu_die: a CU DIE which including @addr
> 
> s/cu_die/sp_die/
> 
> And it doesn't look like a CU DIE, anyway.

Oops, right!
Thank you for review :)

> 
> 
> Thanks,
> Namhyung
> 
> 
>> + * @addr: target address
>> + * @die_mem: a buffer for result DIE
>> + *
>> + * Search an inlined function DIE which includes @addr. Stores the
>> + * DIE to @die_mem and returns it if found. Returns NULL if failed.
>> + * Even if several inlined functions are expanded recursively, this
>> + * doesn't trace it down, and returns the topmost one.
>> + */
>> +Dwarf_Die *die_find_inlinefunc_next(Dwarf_Die *sp_die, Dwarf_Addr addr,
>> +				    Dwarf_Die *die_mem)
>> +{
>> +	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
>> +}


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


