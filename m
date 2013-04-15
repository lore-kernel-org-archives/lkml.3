Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3DOEaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:30:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49999 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3DOEax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:30:53 -0400
X-Spam-Score: -100.8
Message-ID: <516B8253.7010104@asianux.com>
Date: Mon, 15 Apr 2013 12:30:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel: kallsyms: memory override issue, need check
 destination buffer length
References: <51662AC7.1090004@asianux.com> <87eheh4sls.fsf@rustcorp.com.au> <51664B04.7000207@asianux.com> <87y5ck8s5x.fsf@rustcorp.com.au>
In-Reply-To: <87y5ck8s5x.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月15日 10:05, Rusty Russell wrote:
> Chen Gang <gang.chen@asianux.com> writes:
>> >   We don't export any symbols > 128 characters, but if we did then
>> >   kallsyms_expand_symbol() would overflow the buffer handed to it.
>> >   So we need check destination buffer length when copying.
>> >
>> >   the related test:
>> >     if we define an EXPORT function which name more than 128.
>> >     will panic when call kallsyms_lookup_name by init_kprobes on booting.
>> >     after check the length (provide this patch), it is ok.
>> >
>> >   Implementaion:
>> >     add additional destination buffer length parameter (maxlen)
>> >     if uncompressed string is too long (>= maxlen), it will be truncated.
>> >     not check the parameters whether valid, since it is a static function.
> Found a bug already:
> 
> kernel/kallsyms.c: In function ‘kallsyms_lookup’:
> kernel/kallsyms.c:305:78: error: negative width in bit-field ‘<anonymous>’
> kernel/kallsyms.c: In function ‘lookup_symbol_name’:
> kernel/kallsyms.c:327:78: error: negative width in bit-field ‘<anonymous>’
> kernel/kallsyms.c: In function ‘lookup_symbol_attrs’:
> kernel/kallsyms.c:346:69: error: negative width in bit-field ‘<anonymous>’
> 

  oh... it is my fault, I will send v3.

  I only tested kallsyms_on_each_symbol and kallsyms_lookup_name (they
were of cause OK). , not test others.

  ARRAY_SIZE is really valuable to help find bugs.

  and next, after code changes, I should compile it again, at least.

  :-)


> Cheers,


-- 
Chen Gang

Asianux Corporation
