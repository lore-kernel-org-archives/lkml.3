Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3KHJfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:35:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3KHJfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:35:31 -0500
Date: Fri, 8 Nov 2013 10:34:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
Message-ID: <20131108093455.GA1230@krava.brq.redhat.com>
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
 <1383884605-30968-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383884605-30968-3-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 09:23:25PM -0700, David Ahern wrote:

SNIP

>  
> +static void mmap_output_fini(struct perf_record *rec)
> +{
> +	off_t len;
> +	int fd;
> +
> +	if (!rec->mmap.use)
> +		return;
> +
> +	rec->mmap.use = false;
> +
> +	len = rec->session->header.data_offset + rec->bytes_written;
> +	fd = rec->file.fd;
> +
> +	munmap(rec->mmap.addr, rec->mmap.out_size);
> +	rec->mmap.addr = NULL;
> +
> +	if (ftruncate(fd, len) != 0)
> +		pr_err("ftruncate failed\n");

I think we should fail here and dont let the finishing
code run on probably corrupted file.

the code that process build IDs could even get stuck

jirka
