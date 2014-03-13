Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaCMUHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:07:37 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbaCMUHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:07:34 -0400
Date: Thu, 13 Mar 2014 21:07:33 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140313200733.GY22728@two.firstfloor.org>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-2-git-send-email-andi@firstfloor.org>
 <20140311133810.GE22678@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311133810.GE22678@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 02:38:11PM +0100, Jiri Olsa wrote:
> On Wed, Mar 05, 2014 at 11:49:31AM -0800, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> 
> SNIP
> 
> > +jsmntok_t *parse_json(const char *fn, char **map, size_t *size, int *len)
> > +{
> > +	jsmn_parser parser;
> > +	jsmntok_t *tokens;
> > +	jsmnerr_t res;
> > +	unsigned sz;
> > +
> > +	*map = mapfile(fn, size);
> > +	if (!*map)
> > +		return NULL;
> > +	/* Heuristic */
> > +	sz = *size * 16;
> > +	tokens = malloc(sz);
> > +	if (!tokens)
> > +		goto error;
> > +	jsmn_init(&parser);
> > +	res = jsmn_parse(&parser, *map, *size, tokens,
> > +			 sz / sizeof(jsmntok_t));
> > +	if (res != JSMN_SUCCESS) {
> > +		fprintf(stderr, "%s: json error %d\n", fn, res);
> 
> use pr_err

dito.
-Andi
