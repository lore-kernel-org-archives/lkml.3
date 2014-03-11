Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaCKNim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbaCKNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:38:38 -0400
Date: Tue, 11 Mar 2014 14:38:11 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140311133810.GE22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:31AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 

SNIP

> +jsmntok_t *parse_json(const char *fn, char **map, size_t *size, int *len)
> +{
> +	jsmn_parser parser;
> +	jsmntok_t *tokens;
> +	jsmnerr_t res;
> +	unsigned sz;
> +
> +	*map = mapfile(fn, size);
> +	if (!*map)
> +		return NULL;
> +	/* Heuristic */
> +	sz = *size * 16;
> +	tokens = malloc(sz);
> +	if (!tokens)
> +		goto error;
> +	jsmn_init(&parser);
> +	res = jsmn_parse(&parser, *map, *size, tokens,
> +			 sz / sizeof(jsmntok_t));
> +	if (res != JSMN_SUCCESS) {
> +		fprintf(stderr, "%s: json error %d\n", fn, res);

use pr_err

jirka
