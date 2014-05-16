Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaEPGkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 02:40:55 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52389 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaEPGky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 02:40:54 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 12/20] perf tools: Add ->sort() member to struct sort_entry
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
	<1399876133-17963-13-git-send-email-namhyung@kernel.org>
	<20140515134310.GG25858@krava.brq.redhat.com>
Date: Fri, 16 May 2014 15:40:52 +0900
In-Reply-To: <20140515134310.GG25858@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 15 May 2014 15:43:10 +0200")
Message-ID: <87wqdmjkej.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 15:43:10 +0200, Jiri Olsa wrote:
> On Mon, May 12, 2014 at 03:28:45PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +static int64_t
>> +sort__sym_sort(struct hist_entry *left, struct hist_entry *right)
>> +{
>> +	if (!left->ms.sym || !right->ms.sym)
>> +		return cmp_null(left->ms.sym, right->ms.sym);
>> +
>> +	return strcmp(right->ms.sym->name, left->ms.sym->name);
>> +}
>
> why do we need just string comparison for sort?

Because we want to sort them in alphabetical order.

>
>> +
>>  static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
>>  				     u64 ip, char level, char *bf, size_t size,
>>  				     unsigned int width)
>> @@ -255,6 +271,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
>>  struct sort_entry sort_sym = {
>>  	.se_header	= "Symbol",
>>  	.se_cmp		= sort__sym_cmp,
>> +	.se_sort	= sort__sym_sort,
>>  	.se_snprintf	= hist_entry__sym_snprintf,
>>  	.se_width_idx	= HISTC_SYMBOL,
>
> so when we insert entries into hists we use se_cmp to group them
> via hist_entry__cmp
>
> the we sort this hists based on output and use se_sort to group
> them via __hists__insert_output_entry
>
> why can't we use just cmp?

As I said, the output should be sorted by symbol name.  IOW, in order to
group entries in input stage, putting them into a correct group is
important, but for output stage, the order is also important.

Thanks,
Namhyung
