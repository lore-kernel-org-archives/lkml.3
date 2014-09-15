Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbaIOIhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:37:52 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43925 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbaIOIht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:37:49 -0400
Message-ID: <5416A558.3070109@converseincode.com>
Date: Mon, 15 Sep 2014 01:37:44 -0700
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
CC: agk@redhat.com, clm@fb.com, David Miller <davem@davemloft.net>,
        fabf@skynet.be, Herbert Xu <herbert@gondor.apana.org.au>,
        jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com,
        thomas.lendacky@amd.com, linux-ima-user@lists.sourceforge.net,
        qat-linux@intel.com, d.kasatkin@samsung.com,
        Bruce Allan <bruce.w.allan@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, john.griffin@intel.com,
        linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ima-devel@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>, zohar@linux.vnet.ibm.com,
        linux-btrfs@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [dm-devel] [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove
 use of VLAIS in crypto code
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-2-git-send-email-behanw@converseincode.com> <CAHXqBFK=o2Q3CUPWaL_8TDBJbGjfEOx_HnQzooy33wuKWyu5Gw@mail.gmail.com>
In-Reply-To: <CAHXqBFK=o2Q3CUPWaL_8TDBJbGjfEOx_HnQzooy33wuKWyu5Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/14 01:06, Michał Mirosław wrote:
> 2014-09-15 9:30 GMT+02:00  <behanw@converseincode.com>:
> [...]
>> +#define SHASH_DESC_ON_STACK(shash, tfm)                                  \
>> +       char __desc[sizeof(struct shash_desc) +                   \
>> +               crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
>> +       struct shash_desc *shash = (struct shash_desc *)__desc
>> +
> char shash##__desc[] or similar? Otherwise it won't work if you use
> this macro twice in the same block.
>
> Best Regards,
> Michał Mirosław
Good thinking. Will fix.

Behan

-- 
Behan Webster
behanw@converseincode.com

