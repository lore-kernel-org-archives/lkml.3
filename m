Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3LXGvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 01:51:41 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46681 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3LXGvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 01:51:40 -0500
Message-ID: <52B92EEE.2020803@hitachi.com>
Date: Tue, 24 Dec 2013 15:51:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 1/3] [CLEANUP] perf-probe: Expand given path to absolute
 path
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal> <20131220100257.7169.60537.stgit@kbuild-fedora.novalocal> <20131220180031.GA28878@ghostprotocols.net> <52B75B0D.6010401@hitachi.com> <20131223142832.GF28878@ghostprotocols.net>
In-Reply-To: <20131223142832.GF28878@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/23 23:28), Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 23, 2013 at 06:35:09AM +0900, Masami Hiramatsu escreveu:
>> (2013/12/21 3:00), Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Dec 20, 2013 at 10:02:57AM +0000, Masami Hiramatsu escreveu:
>>>> Expand given path to absolute path in option parser,
>>>> except for a module name. Instead of expanding it later,
>>>> this get the absolute path in early stage.
>>>
>>> What is the problem this solves?
>>>
>>> Can you provide some output showing the problem, i.e. before you apply
>>> this patch?
>>
>> No, this is just a code cleanup, for the later enhancements.
> 
> Ok, this is just a cleanup, but what does this cleanup achieves? Why is
> it better to "getting the absolute path in early stage"?
> 
> I.e. you're describing what the patch does, and I can see it from
> reading code, but why is it good to do it in an early stage?

---
Since realpath at the later stage in processing several probe point
can be called several times(even if currently doesn't, it can happen
when we expands the feature), it is waste of the performance.
Processing it once at the early stage can avoid that.
---

Is that good enough for you? :)

> 
>> Should I put it into the next patch?
> 
> No need for that, just, please, clarify why it is needed.
>  

OK, I'll do that:)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


