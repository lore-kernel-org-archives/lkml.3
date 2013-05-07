Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab3EGNrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:47:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381Ab3EGNrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:47:21 -0400
Message-ID: <518905E6.5050502@suse.cz>
Date: Tue, 07 May 2013 15:47:18 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Libo Chen <clbchenlibo.chen@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] menuconfig: fix NULL pointer dereference when searching
 a symbol
References: <518869BB.2020808@huawei.com> <20130507132159.GA15137@free.fr>
In-Reply-To: <20130507132159.GA15137@free.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.5.2013 15:21, Yann E. MORIN wrote:
> Li, All,
> 
> On Tue, May 07, 2013 at 10:40:59AM +0800, Li Zefan wrote:
>> Searching PPC_EFIKA results segmentation fault, and it's because
>> get_symbol_prop() returns NULL.
>>
>> In this case CONFIG_PPC_EFIKA is defined in arch/powerpc/platforms/
>> 52xx/Kconfig, so it won't be parsed if ARCH!=PPC, but menuconfig
>> knows this symbol when it parses sound/soc/fsl/Kconfig:
>>
>> config SND_MPC52xx_SOC_EFIKA
>>         tristate "SoC AC97 Audio support for bbplan Efika and STAC9766"
>>         depends on PPC_EFIKA
>>
>> This bug was introduced by commit bcdedcc1afd6 ("menuconfig: print more
>> info for symbol without prompts").
>>
>> Reported-by: Borislav Petkov <bp@alien8.de>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Michal, I'll get this in my tree, and will send a pull-request to you
> later (I may have a few other smallish fixes shortly).

It's difficult to apply this to kbuild.git#kconfig, because the bug that
it is fixing is not there. I will send it to Linus by mail.

Michal
