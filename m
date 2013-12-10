Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3LJBFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 20:05:44 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65343 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3LJBFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 20:05:42 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-f4-52a668e4269e
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 08/17] tracing/probes: Split [ku]probes_fetch_type_table
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org>
	<1386570005-3368-9-git-send-email-namhyung@kernel.org>
	<52A5DD30.4080101@hitachi.com>
Date: Tue, 10 Dec 2013 10:05:40 +0900
In-Reply-To: <52A5DD30.4080101@hitachi.com> (Masami Hiramatsu's message of
	"Tue, 10 Dec 2013 00:09:36 +0900")
Message-ID: <878uvtldln.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Tue, 10 Dec 2013 00:09:36 +0900, Masami Hiramatsu wrote:
> (2013/12/09 15:19), Namhyung Kim wrote:
>> @@ -398,21 +376,21 @@ static const struct fetch_type *find_fetch_type(const char *type)
>>  
>>  		switch (bs) {
>>  		case 8:
>> -			return find_fetch_type("u8");
>> +			return find_fetch_type("u8", ftbl);
>>  		case 16:
>> -			return find_fetch_type("u16");
>> +			return find_fetch_type("u16", ftbl);
>>  		case 32:
>> -			return find_fetch_type("u32");
>> +			return find_fetch_type("u32", ftbl);
>>  		case 64:
>> -			return find_fetch_type("u64");
>> +			return find_fetch_type("u64", ftbl);
>>  		default:
>>  			goto fail;
>>  		}
>>  	}
>>  
>> -	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
>> -		if (strcmp(type, fetch_type_table[i].name) == 0)
>> -			return &fetch_type_table[i];
>> +	for (i = 0; i < NR_FETCH_TYPES; i++)
>
> Hmm, I consider this should use correct length of given array. Thus,
> I'd like recommend you to do;
> giving the size of fetch_type_table, or define *probe_fetch_type_table with
> NR_FETCH_TYPES size, or introduce a gatekeeper, e.g. special terminator entry
> for initializing.

Ah, okay.  So I'd like to go with the gatekeeper approach since I added
the NR_FETCH_TYPES only for iterating the table so no need to keep the
size itself.  And it might be better for additional change in the
future.

Thanks,
Namhyung

>
>> +/* Fetch type information table */
>> +const struct fetch_type uprobes_fetch_type_table[] = {
>
> For example, here if I see the NR_FETCH_TYPES in above [], I can ensure
> the table has at least that size (and if there is a space, it will be
> filled with zero, in that case, we just need to add a checking
> fetch_type_table[i].name != NULL).
>
> Thank you,
