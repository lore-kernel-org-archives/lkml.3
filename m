Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3JHNXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:23:01 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:54709 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3JHNW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:22:58 -0400
Date: Tue, 8 Oct 2013 10:22:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/7] perf util: Add findnew method to intlist
Message-ID: <20131008132250.GC4018@ghostprotocols.net>
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
 <1380395584-9025-7-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380395584-9025-7-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Sep 28, 2013 at 01:13:03PM -0600, David Ahern escreveu:
> Similar to other findnew based methods if the requested
> object is not found, add it to the list.

> +struct int_node *intlist__findnew(struct intlist *ilist, int i)
> +{
> +	struct int_node *node = intlist__find(ilist, i);
> +
> +	if ((node == NULL) && (intlist__add(ilist, i) == 0))
> +		node = intlist__find(ilist, i);
> +
> +	return node;


This is what I should have pointed out earlier: Can't we have a
find_and_add_if_not_found routine as we have elsewhere?

Calling intlist__find() after intlist__add() looks really ugly :-\

Please take a look at my perf/core branch, several patches of this
series are there, one with minor change.

- Arnaldo

> +}
> +
>  static int intlist__parse_list(struct intlist *ilist, const char *s)
>  {
>  	char *sep;
> diff --git a/tools/perf/util/intlist.h b/tools/perf/util/intlist.h
> index 0eb00ac..aa6877d 100644
> --- a/tools/perf/util/intlist.h
> +++ b/tools/perf/util/intlist.h
> @@ -24,6 +24,7 @@ int intlist__add(struct intlist *ilist, int i);
>  
>  struct int_node *intlist__entry(const struct intlist *ilist, unsigned int idx);
>  struct int_node *intlist__find(struct intlist *ilist, int i);
> +struct int_node *intlist__findnew(struct intlist *ilist, int i);
>  
>  static inline bool intlist__has_entry(struct intlist *ilist, int i)
>  {
> -- 
> 1.7.10.1
