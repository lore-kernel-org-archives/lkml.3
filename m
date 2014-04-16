Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaDPKLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:11:34 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58785 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaDPKLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:11:32 -0400
Message-ID: <534E5741.8090908@gmail.com>
Date: Wed, 16 Apr 2014 18:11:13 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: =?UTF-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, akpm@linux-foundation.org,
        liuj97@gmail.com, rientjes@google.com, dhowells@redhat.com,
        mgorman@suse.de, linux-kernel@vger.kernel.org, will.deacon@arm.com,
        linux@arm.linux.org.uk, Geert Uytterhoeven <geert@linux-m68k.org>,
        arnd@arndb.de
Subject: Re: [PATCH v3] arch:unicore32:mm: add devmem_is_allowed() to support
 STRICT_DEVMEM
References: <629583968.18592.1396927216694.JavaMail.root@bj-mail03.pku.edu.cn> <534380F6.7090703@gmail.com> <534C79EE.3030505@gmail.com> <534C7D46.6040602@gmail.com> <534C8073.3060607@gmail.com> <534C899A.2020008@gmail.com> <20140416090511.GB12866@dhcp22.suse.cz>
In-Reply-To: <20140416090511.GB12866@dhcp22.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 05:05 PM, Michal Hocko wrote:
> On Tue 15-04-14 09:21:30, Chen Gang wrote:
> [...]
>> diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
>> index 39decb6..ae327e4 100644
>> --- a/arch/unicore32/include/asm/io.h
>> +++ b/arch/unicore32/include/asm/io.h
> 
> There is already quite a mess where the function is defined. We have it
> in mmap.c, init.c, mem.c and s390 defines it in page.h. Is there any
> good reason to add yet another place and pull in additional header files
> dependencies?

It is short enough to be as static inline function. It also can bypass
choosing which ".c" file contents the implementation (arm{64} declare it
in "io.h").

So recommend devmem_is_allowed() in arm{64} are also "static inline".

Hmm... is it possible to move the static inline implementation from
"io.h" to "page.h", since all other archs declare or implement in
"page.h" related header file.


> Why not follow x86 here? Or even better git rid of the code duplication
> and provide generic implementation which different arches can reuse and
> extend? arm{64}, unicore32 seem to be identical. Powepc and x86 have an
> additional test to the core one used by the above arches. Only tile
> seems to be be doing something completely different.
> 

For me, need not put it in 'asm-generic':

 - 9/29 archs need it, so at present, it is not generic enough.

 - most of them are different, which hard to find generic one.

   - frv and m32r same, but different with others.

   - arm{64} and unicore32 same, but different with others.

   - powerpc, s390, tile, and x86 are different with each other.

If we are sure most new archs will support devmem_is_allowed(), and at
least, 40% are the same, we can continue to consider about whether put
it in 'asm-generic' or not.


Altogether, for me, let the related declaration/implementation in
"page.h" or related header file will be fine, at least present, it is
not need to put it in 'asm-generic'.


[...]

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
