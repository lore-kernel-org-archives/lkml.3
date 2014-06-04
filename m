Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaFDIZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:25:10 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56387 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFDIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:25:08 -0400
Message-ID: <538ED7DE.5070508@hitachi.com>
Date: Wed, 04 Jun 2014 17:25:02 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf/probe: Fix perf probe to find correct
 variable DIE
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp> <53872A72.6040007@hitachi.com> <20140603203823.GG3696@kernel.org>
In-Reply-To: <20140603203823.GG3696@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/04 5:38), Arnaldo Carvalho de Melo wrote:
> Now trying to reference a bogus member name:
> 
> [root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->BOGUS:string'
> result(type:filename) has no member BOGUS.
> Failed to find 'result' in this function.
>   Error: Failed to add events. (-22)
> [root@zoo ~]#
> 
> No segfault, albeit it produces a bogus error message, as it clearly
> _finds_ the 'result' variable, its just that it is of a struct type that
> _has_ no such 'BOGUS' _member_.

Right, I'll fix that.

> 
> Also I suggest removing that last "Error:" line, what is its value for
> users or developers?

It tells them the perf probe finally failed because of an error (with
error code). Indeed that message is bluntness. I'll update it to use
strerr instead of giving mysterious error code.
FYI, if it gets some general errors, like -ENOMEM, will just indicate
the last error message.

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


