Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab3HIJP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 05:15:56 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42962 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965456Ab3HIJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 05:15:55 -0400
Message-ID: <5204B346.4010904@hitachi.com>
Date: Fri, 09 Aug 2013 18:15:50 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 03/13] tracing/kprobes: Make stack and memory fetch functions
 static
References: <1375261410-11219-1-git-send-email-namhyung@kernel.org> <1375261410-11219-4-git-send-email-namhyung@kernel.org> <51FF6A89.9020404@hitachi.com> <87y58bwc44.fsf@sejong.aot.lge.com>
In-Reply-To: <87y58bwc44.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/09 16:35), Namhyung Kim wrote:
> Hi Masami-san,
> 
> On Mon, 05 Aug 2013 18:04:09 +0900, Masami Hiramatsu wrote:
>> (2013/07/31 18:03), Namhyung Kim wrote:
>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>
>>> Those fetch functions need to be implemented differently for kprobes
>>> and uprobes.  Since the symbol and deref fetch functions don't call
>>> those directly anymore, we can make them static and implement them
>>> separately.
>>
>> Hmm, I think this should be done in 1/13, since this is partially
>> reverted it in the same series. If you concern about tweaking other
>> one's patch, you can add you singed-off-by to it. :)
> 
> The problem is that it should be marked static after converting to
> ->fetch() member.  Otherwise the symbol and deref fetch method won't see
> memory fetch functions like:

Ah, right. We still use it from deref. :)

Thanks!


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


