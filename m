Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaBDKFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 05:05:42 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:34211 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaBDKFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 05:05:34 -0500
Message-ID: <52F0BB60.8020402@hitachi.com>
Date: Tue, 04 Feb 2014 19:05:20 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: Re: [PATCH -tip v2 4/8] perf-probe: Use _stext based address
 instead of the symbol name
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <20140129091459.22141.29467.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <87d2j43aav.fsf@sejong.aot.lge.com> <52EF541E.8040802@hitachi.com> <52F0B7C5.8080609@hitachi.com>
In-Reply-To: <52F0B7C5.8080609@hitachi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/04 18:49), Masami Hiramatsu wrote:
>>> Couldn't we just use kmap->ref_reloc_sym instead of the hard-coded
>>> "_stext"?  You might want to check the Adrian's recent kaslr fixes (now
>>> in tip/perf/urgent).
>>
>> Yeah, I just found Adrian's work and this series must be updated for that,
>> because symbol's address is now based on the real (relocated) address.
>> OK, I'll try to use a symbol in ref_reloc_sym. ;) Thank you for pointed it out!
> 
> Hmm, I've tested using ref_reloc_sym for new version, setting probes was OK,
> but getting the address of "_text" always failed. It seems that the kmaps
> doesn't make a symbol for "_text", on the other hand, "_stext" seems always
> available. So I think there are two ways to fix this, use "_stext" as this
> version, or use "_text" and fix dso__load_sym to load "_text" as a function
> symbol if exist.
> I'm not sure why the "_text" is not loaded, is that a policy?

Ah, I see. "_text" is not a function, just a label. That is why it
is not found in function map. Hmm, in that case, maybe I should use
a special case for checking reference symbol is a ref_reloc_sym and
if so, use ref_reloc_sym->unrelocated_addr.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


