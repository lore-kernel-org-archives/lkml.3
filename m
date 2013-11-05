Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3KECKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 21:10:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43262 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab3KECKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 21:10:32 -0500
X-AuditID: 9c93016f-b7bc7ae0000010eb-3f-527853977dc4
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 11/13] tracing/kprobes: Add priv argument to fetch functions
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<1383029621-7384-12-git-send-email-namhyung@kernel.org>
	<20131104160914.GA8595@redhat.com>
Date: Tue, 05 Nov 2013 11:10:31 +0900
In-Reply-To: <20131104160914.GA8595@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 17:09:14 +0100")
Message-ID: <87r4av1tuw.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Nov 2013 17:09:14 +0100, Oleg Nesterov wrote:
> See my replies to 0/13. Lets assume that you agree that get_user_vaddr()
> doesn't need tu->inode.

Okay.

>
> On 10/29, Namhyung Kim wrote:
>>
>> This argument is for passing private data structure to each fetch
>> function and will be used by uprobes.
>
> In this case, why do we need this "void *priv"? It actually becomes
> "bool need_addr_translation".

Right.  I added it because the deref method is used for both of kprobes
and uprobes and it only needed for uprobes.  And I thought if we need
something for kprobes later, it can be reused so make it general.

>
> Can't we avoid it? Can't we just add FETCH_MTD_memory_notranslate ?
> kprobes should use the same methods for FETCH_MTD_memory*, uprobes
> should obviously adjust the addr in FETCH_MTD_memory.
>
> Then (afaics) we need a single change in parse_probe_arg(),
>
> 	-	dprm->fetch = t->fetch[FETCH_MTD_memory];
> 	+	dprm->fetch = t->fetch[FETCH_MTD_memory_notranslate];
>
> Yes, this will blow *probes_fetch_type_table[], but looks simpler.

Looks good to me too, thanks! :)

>
> And. This way it would be simple to teach parse_probe_arg('@') to use
> _notranslate, say, "@=addr" or whatever.

Yeah, it'll be useful at least for fetching data in anon pages.

Thanks,
Namhyung
