Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaEONng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:43:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaEONnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:43:35 -0400
Date: Thu, 15 May 2014 15:43:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 12/20] perf tools: Add ->sort() member to struct
 sort_entry
Message-ID: <20140515134310.GG25858@krava.brq.redhat.com>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
 <1399876133-17963-13-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399876133-17963-13-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 03:28:45PM +0900, Namhyung Kim wrote:

SNIP

> +static int64_t
> +sort__sym_sort(struct hist_entry *left, struct hist_entry *right)
> +{
> +	if (!left->ms.sym || !right->ms.sym)
> +		return cmp_null(left->ms.sym, right->ms.sym);
> +
> +	return strcmp(right->ms.sym->name, left->ms.sym->name);
> +}

why do we need just string comparison for sort?

> +
>  static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
>  				     u64 ip, char level, char *bf, size_t size,
>  				     unsigned int width)
> @@ -255,6 +271,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *he, char *bf,
>  struct sort_entry sort_sym = {
>  	.se_header	= "Symbol",
>  	.se_cmp		= sort__sym_cmp,
> +	.se_sort	= sort__sym_sort,
>  	.se_snprintf	= hist_entry__sym_snprintf,
>  	.se_width_idx	= HISTC_SYMBOL,

so when we insert entries into hists we use se_cmp to group them
via hist_entry__cmp

the we sort this hists based on output and use se_sort to group
them via __hists__insert_output_entry

why can't we use just cmp?

jirka
