Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaANXpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:45:49 -0500
Received: from mga03.intel.com ([143.182.124.21]:17186 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaANXpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:45:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,659,1384329600"; 
   d="scan'208";a="458861943"
Message-ID: <52D5CC2A.7030906@linux.intel.com>
Date: Tue, 14 Jan 2014 15:45:46 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
References: <20140114133125.GB26942@localhost>	<CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>	<52D5C6F2.7090607@linux.intel.com> <CAGXu5jJLarLeYef0eEfEuVS4pDJf_3my-5BV1O6RX+LP7=hUag@mail.gmail.com>
In-Reply-To: <CAGXu5jJLarLeYef0eEfEuVS4pDJf_3my-5BV1O6RX+LP7=hUag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 03:31 PM, Kees Cook wrote:
> On Tue, Jan 14, 2014 at 3:23 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> On 01/14/2014 02:33 PM, Kees Cook wrote:
>>>
>>> Can you tell me how the initrd for quantal-core-x86_64.cgz was built
>>> in the qemu instances you're using? It seems like all the failures
>>> point to a problem with how kASLR is interacting with the initrd.
>>>
>>
>> If kASLR somehow causes the kernel to collide with the initrd that would
>> be problem...
> 
> Agreed, but I can't reproduce this yet. The initrd is on the list of
> areas that get avoided, so the fundamental design isn't broken, but
> clearly something is busted.
> 
> How long has tip:x86/kaslr been sitting in linux-next? If this is some
> interaction between kaslr and something else, perhaps merge order just
> happens to be pointing at kaslr?
> 
> Regardless, all my tests so far against next-20140114 and an initramfs
> haven't seen corruption (using the given .config). I don't have the
> same initrd, though, so I'm hoping getting that will trigger the
> glitch.
> 

Given our craptastic ELF parser I'm wondering if we at some point
overrun the kernel "safe memory zone" during decompression/parsing...

	-hpa


