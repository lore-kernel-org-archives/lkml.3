Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3LLF4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:56:09 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58460 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3LLF4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:56:05 -0500
Message-ID: <52A94FED.3020705@hitachi.com>
Date: Thu, 12 Dec 2013 14:55:57 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: Re: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain()
 for tracing handlers
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-17-git-send-email-namhyung@kernel.org> <52A6EFD7.8050602@hitachi.com> <20131210155744.GA21466@redhat.com> <52A7C347.1060402@hitachi.com> <20131211181155.GA25144@redhat.com>
In-Reply-To: <20131211181155.GA25144@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/12 3:11), Oleg Nesterov wrote:
> On 12/11, Masami Hiramatsu wrote:
>>
>> (2013/12/11 0:57), Oleg Nesterov wrote:
>>> On 12/10, Masami Hiramatsu wrote:
>>>>
>>>> and isn't it better to increment
>>>> miss-hit counter of the uprobe?
>>>
>>> What do you mean? This is not miss-hit and ->utask == NULL is quite normal.
>>
>> But it could skip the handler_chain silently. It could confuse users
>> why their probe doesn't hit as expected.
> 
> No, we will restart the same (probed) instruction, handle_swbp()
> will be called again, get_utask() will be called again.

Hmm, in that case, how would you avoid infinite recursive loop??
Would you repeat it until get_utask() != NULL?

> Not to mention that (in practice) if GFP_KERNEL fails the task is
> already killed.
> 
>>> For example, on ppc it can be always NULL because ppc likely emulates the
>>> probed insn.
>>
>> Hmm, in that case, should uprobes handlers never be called on ppc with
>> this change?
> 
> Why? With this change ppc will have ->utask != NULL even if it doesn't
> need it at all.

Ah, I see. This changes that.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


