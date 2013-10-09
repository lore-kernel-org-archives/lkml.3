Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JINeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab3JINeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:34:09 -0400
Date: Wed, 9 Oct 2013 15:33:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - RFC
Message-ID: <20131009133331.GC5459@krava.redhat.com>
References: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 08:05:59PM -0600, David Ahern wrote:

SNIP

> +
> +	if (size > remaining) {
> +		memcpy(rec->mmap_addr + rec->mmap_offset, buf, remaining);
> +		rec->bytes_written += remaining;
> +
> +		size -= remaining;
> +		buf  += remaining;
> +
> +		msync(rec->mmap_addr, rec->mmap_size, MS_ASYNC);
> +		munmap(rec->mmap_addr, rec->mmap_size);

do we need msync call if munmap is called right away?


> +		goto do_mmap;

SNIP

> +	if (rec->use_mmap) {
> +		off_t len = rec->bytes_at_mmap_start + rec->bytes_written;
> +
> +		rec->use_mmap = false;
> +		msync(rec->mmap_addr, rec->mmap_size, MS_ASYNC);
> +		munmap(rec->mmap_addr, rec->mmap_size);

ditto

thanks,
jirka
