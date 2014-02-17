Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaBQVG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:06:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53948 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaBQVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:06:57 -0500
Message-ID: <530279EC.5010605@infradead.org>
Date: Mon, 17 Feb 2014 13:06:52 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kent Overstreet <kmo@daterainc.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
In-Reply-To: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 01:00 PM, Geert Uytterhoeven wrote:
> On Fri, Feb 14, 2014 at 8:04 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>>    bcache: Minor fixes from kbuild robot
> 
>> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
>> index 4f6b594..3f74b4b 100644
>> --- a/drivers/md/bcache/bset.c
>> +++ b/drivers/md/bcache/bset.c
>> @@ -23,7 +23,7 @@ void bch_dump_bset(struct btree_keys *b, struct bset *i, unsigned set)
>>         for (k = i->start; k < bset_bkey_last(i); k = next) {
>>                 next = bkey_next(k);
>>
>> -               printk(KERN_ERR "block %u key %zi/%u: ", set,
>> +               printk(KERN_ERR "block %u key %li/%u: ", set,
>>                        (uint64_t *) k - i->d, i->keys);
>>
>>                 if (b->ops->key_dump)
> 
> On 32-bit (m68k):
> drivers/md/bcache/bset.c: In function ‘bch_dump_bset’:
> drivers/md/bcache/bset.c:27: warning: format ‘%li’ expects type ‘long
> int’, but argument 3 has type ‘int’
> 
> What are you trying to print here? It looks a bit strange to me.
> Technically, the difference between two pointers is of type ptrdiff_.
> The kernel had
> 
> typedef __kernel_ptrdiff_t      ptrdiff_t;
> 
> and
> 
> #if __BITS_PER_LONG != 64
> typedef unsigned int    __kernel_size_t;
> typedef int             __kernel_ssize_t;
> typedef int             __kernel_ptrdiff_t;
> #else
> typedef __kernel_ulong_t __kernel_size_t;
> typedef __kernel_long_t __kernel_ssize_t;
> typedef __kernel_long_t __kernel_ptrdiff_t;
> #endif
> 
> So I'd expect "%zi" to be the right way, and a quick test compile on
> 32-bit (m68k)
> and 64-bit (amd64) comfirms that. What was wrong with it?

The kernel supports 't' (%t) for ptrdiff_t (same as glibc),
so %ti should work (or %tu).

-- 
~Randy
