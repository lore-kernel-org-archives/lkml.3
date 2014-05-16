Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaEPLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:25:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaEPLZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:25:55 -0400
Date: Fri, 16 May 2014 13:25:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/6] Revert "perf: Disable PERF_RECORD_MMAP2 support"
Message-ID: <20140516112514.GC19475@krava.brq.redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399999697-65875-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:48:13PM -0400, Don Zickus wrote:

SNIP

> -		/*
> - 		 * Anon maps don't have the execname.
> - 		 */
> -		if (n < 4)
> +		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
> +		       &event->mmap2.start, &event->mmap2.len, prot,
> +		       &event->mmap2.pgoff, &event->mmap2.maj,
> +		       &event->mmap2.min,
> +		       &ino, execname);
> +
> +		event->mmap2.ino = (u64)ino;
> +
> +		if (n < 7)
>  			continue;

any reason for changing this from 'if (n != 8)' ?

jirka
