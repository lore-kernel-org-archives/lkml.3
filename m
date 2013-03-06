Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3CFJRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:17:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:34475 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab3CFJRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:17:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,793,1355126400"; 
   d="scan'208";a="209590888"
Message-ID: <51370990.5040508@linux.intel.com>
Date: Wed, 06 Mar 2013 01:17:04 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: Linux 3.9-rc1
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com> <20130306080642.GA535@polaris.bitmath.org>
In-Reply-To: <20130306080642.GA535@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 12:06 AM, Henrik Rydberg wrote:
> Hi Linus, Peter,
> 
>> I don't know if it's just me, but this merge window had more "Uhhuh"
>> moments than I'm used to. I stopped merging a couple of times, because
>> we had bugs that looked really scary, but thankfully each time people
>> were on them like paparazzi on Justin Bieber. Special thanks to Peter,
>> Ted and Rafael (and the people who reported the bugs too!) for being
>> so responsive. It could have been so much worse.
> 
> Or not. ;-) This commit breaks boot on my MacBookAir3,1:
> 
> commit 8d57470d8f859635deffe3919d7d4867b488b85a
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Fri Nov 16 19:38:58 2012 -0800
> 
>     x86, mm: setup page table in top-down
>     
>     Get pgt_buf early from BRK, and use it to map PMD_SIZE from top at first.
>     Then use mapped pages to map more ranges below, and keep looping until
>     all pages get mapped.
> 
> Being a 64-bit apple-EFI machine, it probably runs through an obscure
> path in this patch. I wish I had more vital information, but I get the
> white screen of death, so not much to go on so far.
> 

Adding Yinghai.

Can you get a boot log with "debug memblock=debug" from the last
successful commit point?  Are you booting EFI or BootCamp?

	-hpa


