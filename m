Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3LWKuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 05:50:18 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58640 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3LWKuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 05:50:17 -0500
Message-ID: <52B81562.5000607@hitachi.com>
Date: Mon, 23 Dec 2013 19:50:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip 3/3] perf-probe: Use the actual address as a hint
 for uprobes
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal> <20131220100302.7169.96318.stgit@kbuild-fedora.novalocal> <20131220180351.GC28878@ghostprotocols.net> <52B75F9E.7000802@hitachi.com> <87wqiwc8ly.fsf@sejong.aot.lge.com>
In-Reply-To: <87wqiwc8ly.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/23 16:46), Namhyung Kim wrote:
> On Mon, 23 Dec 2013 06:54:38 +0900, Masami Hiramatsu wrote:
>> (2013/12/21 3:03), Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Dec 20, 2013 at 10:03:02AM +0000, Masami Hiramatsu escreveu:
>> BTW, I'm not sure why debuginfo and nm shows symbol address + 0x400000,
>> and why the perf's map/symbol can remove this offset. Could you tell me
>> how it works?
>> If I can get the offset (0x400000) from binary, I don't need this kind
>> of ugly hacks...
> 
> AFAIK the actual symbol address is what nm (and debuginfo) shows.  But
> perf adjusts symbol address to have a relative address from the start of
> mapping (i.e. file offset) like below:
> 
> 	sym.st_value -= shdr.sh_addr - shdr.sh_offset;

Thanks! this is what I really need!

> This way, we can handle mmap and symbol address almost uniformly
> (i.e. ip = map->start + symbol->address).  But this requires the mmap
> event during perf record.  For perf probe, we might need to synthesize
> mapping info from the section/segment header since it doesn't have the
> mmap event.  Currently, the dso__new_map() just creates a map starts
> from 0.

I think the uprobe requires only the relative address, doesn't that?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


