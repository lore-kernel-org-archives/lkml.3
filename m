Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3CMJVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:21:12 -0400
Received: from multi.imgtec.com ([194.200.65.239]:36010 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3CMJVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:21:09 -0400
Message-ID: <514044FD.2040502@imgtec.com>
Date: Wed, 13 Mar 2013 09:21:01 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Mike Frysinger" <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com> <874ngiwije.fsf@rustcorp.com.au> <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au> <87ppz5usts.fsf@rustcorp.com.au> <20130312233300.9d86d47bb5369923ad520a21@canb.auug.org.au> <87ehfkuq27.fsf@rustcorp.com.au> <20130313063157.GB19681@merkur.ravnborg.org>
In-Reply-To: <20130313063157.GB19681@merkur.ravnborg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_13_09_21_03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 13/03/13 06:31, Sam Ravnborg wrote:
>>  /* Some toolchains use a `_' prefix for all user symbols. */
>> -#ifdef CONFIG_SYMBOL_PREFIX
>> -#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
>> +#ifdef CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX
>> +#define __VMLINUX_SYMBOL(x) _##x
>> +#define __VMLINUX_SYMBOL_STR(x) "_" #x
>> +#define VMLINUX_SYMBOL_PREFIX_STR "_"
>>  #else
>> -#define MODULE_SYMBOL_PREFIX ""
>> +#define __VMLINUX_SYMBOL(x) x
>> +#define __VMLINUX_SYMBOL_STR(x) #x
>> +#define VMLINUX_SYMBOL_PREFIX_STR ""
>>  #endif
> 
> We know the prefix is an underscore. No benefits from defining
> VMLINUX_SYMBOL_PREFIX_STR.

scripts/modpost.c uses the actual prefix string though:

>	if (memcmp(symname, MODULE_SYMBOL_PREFIX,
>		   strlen(MODULE_SYMBOL_PREFIX)) == 0) {
>		mod->unres =
>		  alloc_symbol(symname +
>		               strlen(MODULE_SYMBOL_PREFIX),
> 		               ELF_ST_BIND(sym->st_info) == STB_WEAK,
> 		               mod->unres);

See also my "module: fix symbol versioning with symbol prefixes" patch
for an additional use in modpost.

Having a MODULE_SYMBOL_PREFIX/VMLINUX_SYMBOL_PREFIX_STR seems like the
simplest way to keep this code clean and readable without special cases.

Cheers
James

