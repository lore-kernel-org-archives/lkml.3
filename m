Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab3KZKRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:17:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3KZKRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:17:42 -0500
Date: Tue, 26 Nov 2013 11:17:09 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/3] perf tools: Add perf_data_file__write interface
Message-ID: <20131126101709.GD1267@krava.brq.redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
 <1385130268-10664-2-git-send-email-jolsa@redhat.com>
 <20131125192909.GA27323@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125192909.GA27323@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 04:29:09PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 22, 2013 at 03:24:26PM +0100, Jiri Olsa escreveu:
> >  }
> > +
> > +ssize_t perf_data_file__write(struct perf_data_file *file,
> > +			      void *buf, size_t size)
> > +{
> > +	ssize_t total = size;
> > +
> > +	while (size) {
> > +		ssize_t ret = write(file->fd, buf, size);
> > +
> > +		if (ret < 0) {
> > +			pr_err("failed to write perf data, error: %m\n");
> > +			return -1;
> > +		}
> > +
> > +		size -= ret;
> > +		buf  += ret;
> > +	}
> > +
> > +	return total;
> 
> So this is the functional equivalent of "readn", so please move it to
> just after "readn" and make this just a simple wrapper.

ok, thanks

jirka
