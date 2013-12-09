Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218Ab3LIPJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:09:47 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:42023 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab3LIPJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:09:42 -0500
Message-ID: <52A5DD30.4080101@hitachi.com>
Date: Tue, 10 Dec 2013 00:09:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 08/17] tracing/probes: Split [ku]probes_fetch_type_table
References: <1386570005-3368-1-git-send-email-namhyung@kernel.org> <1386570005-3368-9-git-send-email-namhyung@kernel.org>
In-Reply-To: <1386570005-3368-9-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/09 15:19), Namhyung Kim wrote:
> @@ -398,21 +376,21 @@ static const struct fetch_type *find_fetch_type(const char *type)
>  
>  		switch (bs) {
>  		case 8:
> -			return find_fetch_type("u8");
> +			return find_fetch_type("u8", ftbl);
>  		case 16:
> -			return find_fetch_type("u16");
> +			return find_fetch_type("u16", ftbl);
>  		case 32:
> -			return find_fetch_type("u32");
> +			return find_fetch_type("u32", ftbl);
>  		case 64:
> -			return find_fetch_type("u64");
> +			return find_fetch_type("u64", ftbl);
>  		default:
>  			goto fail;
>  		}
>  	}
>  
> -	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
> -		if (strcmp(type, fetch_type_table[i].name) == 0)
> -			return &fetch_type_table[i];
> +	for (i = 0; i < NR_FETCH_TYPES; i++)

Hmm, I consider this should use correct length of given array. Thus,
I'd like recommend you to do;
giving the size of fetch_type_table, or define *probe_fetch_type_table with
NR_FETCH_TYPES size, or introduce a gatekeeper, e.g. special terminator entry
for initializing.

> +/* Fetch type information table */
> +const struct fetch_type uprobes_fetch_type_table[] = {

For example, here if I see the NR_FETCH_TYPES in above [], I can ensure
the table has at least that size (and if there is a space, it will be
filled with zero, in that case, we just need to add a checking
fetch_type_table[i].name != NULL).

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


