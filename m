Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbaCKKeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbaCKKXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:44 -0400
Date: Tue, 11 Mar 2014 11:23:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140311102302.GA22071@krava.redhat.com>
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

> +{
> +	return t->end - t->start;
> +}
> +
> +/* Is string t equal to s? */
> +int json_streq(char *map, jsmntok_t *t, const char *s)
> +{
> +	unsigned len = t->end - t->start;
> +	return len == strlen(s) && !strncasecmp(map + t->start, s, len);
> +}
> diff --git a/tools/perf/util/json.h b/tools/perf/util/json.h
> new file mode 100644
> index 0000000..0a34aa2
> --- /dev/null
> +++ b/tools/perf/util/json.h
> @@ -0,0 +1,8 @@

missing

#ifndef JSON_H
#define JSON_H

> +#include "jsmn.h"
> +
> +jsmntok_t *parse_json(const char *fn, char **map, size_t *size, int *len);
> +void free_json(char *map, size_t size, jsmntok_t *tokens);
> +int json_line(char *map, jsmntok_t *t);
> +const char *json_name(jsmntok_t *t);
> +int json_streq(char *map, jsmntok_t *t, const char *s);
> +int json_len(jsmntok_t *t);
> -- 
> 1.8.5.3
> 
