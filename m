Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbaGRF3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:29:47 -0400
Received: from ozlabs.org ([103.22.144.67]:58686 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaGRF3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:29:46 -0400
Message-ID: <1405661382.17297.3.camel@concordia>
Subject: Re: [PATCH 05/11] perf, tools: Add support for reading JSON event
 files
From: Michael Ellerman <mpe@ellerman.id.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org, Andi Kleen <ak@linux.intel.com>
Date: Fri, 18 Jul 2014 15:29:42 +1000
In-Reply-To: <1405123165-22666-6-git-send-email-andi@firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
	 <1405123165-22666-6-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 16:59 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a parser for Intel style JSON event files. This allows
> to use an Intel event list directly with perf. The Intel
> event lists can be quite large and are too big to store
> in unswappable kernel memory.

...

> diff --git a/tools/perf/util/jevents.c b/tools/perf/util/jevents.c
> new file mode 100644
> index 0000000..a23f57f
> --- /dev/null
> +++ b/tools/perf/util/jevents.c
> @@ -0,0 +1,246 @@
...
> +
> +static void fixname(char *s)
> +{
> +	for (; *s; s++)
> +		*s = tolower(*s);
> +}

On powerpc our event names are always uppercase, it would be nice if the perf
list output honoured that.

Can we instead just honour whatever case is in the input JSON ?

It looks like the event lookup is already case insensitive.

cheers


