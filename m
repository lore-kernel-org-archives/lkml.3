Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaILM6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:58:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbaILM6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:58:48 -0400
Date: Fri, 12 Sep 2014 14:58:22 +0200
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
Message-ID: <20140912125822.GA23205@krava.brq.redhat.com>
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

you could use zfree
jirka
