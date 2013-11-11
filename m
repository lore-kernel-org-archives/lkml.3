Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3KKL2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:28:06 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60453 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3KKL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:27:57 -0500
Date: Mon, 11 Nov 2013 12:27:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tool: Round mmap pages to power 2
Message-ID: <20131111112754.GD15810@gmail.com>
References: <1383885392-31082-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383885392-31082-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Currently perf requires the -m / --mmap_pages option to be a power of 2.
> To be more user friendly perf should automatically round this up to the
> next power of 2.
> 
> Currently:
>   $ perf record -m 3 -a -- sleep 1
>   --mmap_pages/-m value must be a power of two.sleep: Terminated
> 
> With patch:
>   $ perf record -m 3 -a -- sleep 1
>   rounding mmap pages size to 16384 (4 pages)

Please add 'bytes'.

I'd also suggest generally prefixing tooling messages with some sort of 
'subsystem' prefix, so that in the great and rich network of perf tooling 
subsystems the user knows roughly where the message comes from.

Here it should probably be something like:

    INFO: ring-buffer: Rounding mmap pages size to 16384 bytes (4 pages)

?

While if the message was related to evlists for example and was a hard 
error, it would have this pattern:

    ERROR: event-list: ...

while if it's a warning, it would say:

    WARNING: event-list: ...

I.e. we could match how the kernel handled printk()d message types, 
priorities and subsystems.

Thanks,

	Ingo
