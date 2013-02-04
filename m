Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3BDCEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 21:04:33 -0500
Received: from mail.servus.at ([193.170.194.20]:38840 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab3BDCE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 21:04:29 -0500
Message-ID: <510F10C4.2080903@oberhumer.com>
Date: Mon, 04 Feb 2013 02:37:08 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.12) Gecko/20130105 Thunderbird/10.0.12
MIME-Version: 1.0
To: "kyungsik.lee" <kyungsik.lee@lge.com>
CC: Rajesh Pawar <pawaraj@india.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-kbuild@jasper.es, linux-arm-kernel@lists.infradead.org,
        David Sterba <dsterba@suse.cz>,
        =?UTF-8?B?7J6E7Zqo7KSA?= <hyojun.im@lge.com>,
        =?UTF-8?B?7KCV7LCs6reg?= <chan.jeong@lge.com>, minchan@kernel.org,
        =?UTF-8?B?6rmA64Ko7ZiV?= <namhyung.kim@lge.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Egon Alter <egon.alter@gmx.net>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        raphael.andy.lee@gmail.com
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>, <20130128142510.68092e10.akpm@linux-foundation.org> <254788880.18003.1359493798737.JavaMail.tomcat@be12> <510B6829.7050908@lge.com>
In-Reply-To: <510B6829.7050908@lge.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-01 08:00, kyungsik.lee wrote:
> On 2013-01-30 오전 6:09, Rajesh Pawar wrote:
>>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>> On Sat, 26 Jan 2013 14:50:43 +0900
>>> Kyungsik Lee <kyungsik.lee@lge.com> wrote:
>>>> [...]
>>>>
>>> What's this "with enabled unaligned memory access" thing? You mean "if
>>> the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"? If so,
>>> that's only x86, which isn't really in the target market for this
>>> patch, yes?
>>> It's a lot of code for a 50ms boot-time improvement. Does anyone have
>>> any opinions on whether or not the benefits are worth the cost?
>> BTW, what happened to the proposed LZO update - woudn't it better to merge
>> this first?
>>
>> Also, under the hood LZ4 seems to be quite similar to LZO, so probably
>> LZO speed would also greatly benefit from unaligned access and some other
>> ARM optimisations
>>   
> I didn't test with the proposed LZO update you mentioned. Sorry, which one do
> you mean?
> I did some tests with the latest LZO in the mainline.

In fact you can easily improve LZO decompression speed on armv7 by almost 50%
by adding just a few lines for enabling unaligend access:

armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :          27 MB/sec           84 MB/sec
  LZO-2012    :          44 MB/sec          117 MB/sec
  LZO-2013-UA :          47 MB/sec          167 MB/sec

Please see my other mail to LKML for details.

Cheers,
Markus

> As a result, LZO is not faster in an unaligned access enabled on ARM. Actually
> Slower.
> 
> Decompression time: 336ms(383ms, with unaligned access enabled)
> 
> You may refer to https://lkml.org/lkml/2012/10/7/85 to know more about it.
> 
> Thanks,
> Kyungsik
> 
> 
> Thanks,
> Kyungsik
> 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
