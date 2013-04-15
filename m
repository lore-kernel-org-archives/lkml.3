Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab3DOXRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:17:24 -0400
Received: from ozlabs.org ([203.10.76.45]:50861 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3DOXRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:17:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3]  kernel: kallsyms: memory override issue, need check destination buffer length
In-Reply-To: <516B867A.1080000@asianux.com>
References: <51662AC7.1090004@asianux.com> <87eheh4sls.fsf@rustcorp.com.au> <51664B04.7000207@asianux.com> <87y5ck8s5x.fsf@rustcorp.com.au> <516B867A.1080000@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 15 Apr 2013 15:18:21 +0930
Message-ID: <877gk48hui.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

>   We don't export any symbols > 128 characters, but if we did then
>   kallsyms_expand_symbol() would overflow the buffer handed to it.
>   So we need check destination buffer length when copying.
>
>   the related test:
>     if we define an EXPORT function which name more than 128.
>     will panic when call kallsyms_lookup_name by init_kprobes on booting.
>     after check the length (provide this patch), it is ok.
>
>   Implementaion:
>     add additional destination buffer length parameter (maxlen)
>     if uncompressed string is too long (>= maxlen), it will be truncated.
>     not check the parameters whether valid, since it is a static function.

Thanks, applied.

I've put this in my modules-next branch.

Cheers,
Rusty.
