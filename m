Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaIVMaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:30:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbaIVMaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:30:03 -0400
Date: Mon, 22 Sep 2014 14:29:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 11/14] tools lib api: Adopt fdarray class from perf's
 evlist
Message-ID: <20140922122940.GA18187@krava.brq.redhat.com>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
 <1410358129-9965-12-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410358129-9965-12-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:08:46AM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> +	if (entries == NULL)
> +		return -ENOMEM;
> +
> +	fda->nr_alloc = nr_alloc;
> +	fda->entries  = entries;
> +	return 0;
> +}
> +
> +struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
> +{
> +	struct fdarray *fda = calloc(1, sizeof(*fda));
> +
> +	if (fda != NULL) {
> +		if (fdarray__grow(fda, nr_alloc)) {
> +			free(fda);
> +			fda = NULL;
> +		} else {
> +			fda->nr_autogrow = nr_autogrow;
> +		}
> +	}
> +
> +	return fda;
> +}

fdarray__new is never used..

jirka
