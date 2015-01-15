Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbbAOAmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:42:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44230 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbAOAmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:42:44 -0500
Message-ID: <54B70D01.2050309@gmail.com>
Date: Wed, 14 Jan 2015 17:42:41 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH v2 2/4] perf tools: Add link argument to dso__find_symbol_by_name()
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org> <1421234288-22758-2-git-send-email-namhyung@kernel.org> <54B69B12.50409@gmail.com> <20150115002359.GB2096@sejong>
In-Reply-To: <20150115002359.GB2096@sejong>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/15 5:23 PM, Namhyung Kim wrote:
> On Wed, Jan 14, 2015 at 09:36:34AM -0700, David Ahern wrote:
>>> +	/* return first symbol that has same name (if any) */
>>> +	for (n = rb_prev(n); n; n = rb_prev(n)) {
>>> +		struct symbol_name_rb_node *tmp;
>>> +
>>> +		tmp = rb_entry(n, struct symbol_name_rb_node, rb_node);
>>> +		if (strcmp(tmp->sym.name, s->sym.name))
>>
>> strcmp() == 0?
>
> No, at this point the 's' points to the first symbol that has same
> name.  And if it finds another symbol (tmp) that has same name, it
> updates the s to point to the tmp and continues.  Otherwise it returns
> with the existing symbol (s).

I squinted a bit harder at your v3 and realized that. Was not obvious 
based on the first reading of the loop.

David
