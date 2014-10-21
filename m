Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaJUL1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:27:48 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46402 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbaJUL1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:27:46 -0400
Message-ID: <5446432A.8060204@hitachi.com>
Date: Tue, 21 Oct 2014 20:27:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: Re: [RFC PATCH 5/5] module: Remove stop_machine from module
 unloading
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal> <20140825105555.21089.99958.stgit@kbuild-fedora.novalocal> <87ppdweg5g.fsf@rustcorp.com.au>
In-Reply-To: <87ppdweg5g.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/13 13:40), Rusty Russell wrote:
>> +/*
>> + * MODULE_REF_BASE must be 1, since we use atomic_inc_not_zero() for
>> + * recovering refcnt (see try_release_module_ref() ).
>> + */
>> +#define MODULE_REF_BASE	1
> 
> True, but we could use atomic_add_unless() instead, and make this
> completely generic, right?

Ah, I got it. You might mean replacing atomic_inc_not_zero() in try_release_module_ref
with atomic_add_unless(), then we don't need to make MODULE_REF_BASE=1, is that right?

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


