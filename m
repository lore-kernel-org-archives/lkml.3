Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbaBSAHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:07:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaBSAG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:06:59 -0500
Date: Tue, 18 Feb 2014 16:06:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Daniel M. Weeks" <dan@danweeks.net>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kyungsik Lee <kyungsik.lee@lge.com>
Subject: Re: [PATCH] Fix flags for initramfs LZ4 compression
Message-Id: <20140218160658.fa2802ce37e5169c5b7cf296@linux-foundation.org>
In-Reply-To: <20140215231447.GA30803@dev.danweeks.net>
References: <20140215231447.GA30803@dev.danweeks.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Feb 2014 18:14:57 -0500 "Daniel M. Weeks" <dan@danweeks.net> wrote:

> LZ4 as implemented in the kernel differs from the default method now
> used by the reference implementation of LZ4. Until the in-kernel method
> is updated to support the new default, passing the legacy flag (-l) to
> the compressor is necessary. Without this flag the kernel-generated,
> LZ4-compressed initramfs is junk.

Well that's bad.  Kyungsik, cuold you please comment?

> --- a/scripts/gen_initramfs_list.sh
> +++ b/scripts/gen_initramfs_list.sh
> @@ -257,7 +257,7 @@ case "$arg" in
>                  && compr="lzop -9 -f"
>  		echo "$output_file" | grep -q "\.lz4$" \
>                  && [ -x "`which lz4 2> /dev/null`" ] \
> -                && compr="lz4 -9 -f"
> +                && compr="lz4 -l -9 -f"
>  		echo "$output_file" | grep -q "\.cpio$" && compr="cat"
>  		shift
>  		;;

