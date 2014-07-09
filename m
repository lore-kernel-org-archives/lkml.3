Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbaGIWUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:20:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaGIWUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:20:51 -0400
Date: Thu, 10 Jul 2014 00:20:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/9] perf, tools: Add perf download to download event
 files v4
Message-ID: <20140709222027.GK20938@krava.redhat.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:16:00PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a downloader to automatically download the right
> files from a download site.
> 
> This is implemented as a script calling wget, similar to
> perf archive. The perf driver automatically calls the right
> binary. The downloader is extensible, but currently only
> implements an Intel event download.  It would be straightforward
> to add other sites too for other vendors.
> 
> The downloaded event files are put into ~/.cache/pmu-events, where the
> builtin event parser in util/* can find them automatically.

SNIP

>  	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
> diff --git a/tools/perf/perf-download.sh b/tools/perf/perf-download.sh
> new file mode 100755
> index 0000000..b6e4299
> --- /dev/null
> +++ b/tools/perf/perf-download.sh
> @@ -0,0 +1,57 @@
> +#!/bin/bash
> +# download event files for current cpu for perf
> +
> +WGETOPT=${WGETOPT:---no-verbose --timeout 5}
> +
> +set -e
> +
> +if ! type wget > /dev/null ; then
> +	echo "please install wget"

I guess the other alternative is curl.. could u check for this one as well?

jirka
