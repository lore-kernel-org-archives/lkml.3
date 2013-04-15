Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3DODuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:50:55 -0400
Received: from ozlabs.org ([203.10.76.45]:40390 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab3DODuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:50:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: kallsyms: memory override issue, need check destination buffer length
In-Reply-To: <51664B04.7000207@asianux.com>
References: <51662AC7.1090004@asianux.com> <87eheh4sls.fsf@rustcorp.com.au> <51664B04.7000207@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 15 Apr 2013 11:35:30 +0930
Message-ID: <87y5ck8s5x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
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

Found a bug already:

kernel/kallsyms.c: In function ‘kallsyms_lookup’:
kernel/kallsyms.c:305:78: error: negative width in bit-field ‘<anonymous>’
kernel/kallsyms.c: In function ‘lookup_symbol_name’:
kernel/kallsyms.c:327:78: error: negative width in bit-field ‘<anonymous>’
kernel/kallsyms.c: In function ‘lookup_symbol_attrs’:
kernel/kallsyms.c:346:69: error: negative width in bit-field ‘<anonymous>’

Cheers,
Rusty.
