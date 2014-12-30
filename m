Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaL3FrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 00:47:24 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:40070 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaL3FrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 00:47:23 -0500
MIME-Version: 1.0
In-Reply-To: <1419843707.30395.5.camel@ellerman.id.au>
References: <1419700667-24888-1-git-send-email-bobby.prani@gmail.com>
 <1419700667-24888-2-git-send-email-bobby.prani@gmail.com> <1419843707.30395.5.camel@ellerman.id.au>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 30 Dec 2014 00:46:52 -0500
Message-ID: <CAJhHMCDNGRxWn41Wo+4i3-Y4okpgCyiKwNFXxciZZF=T+nwmgw@mail.gmail.com>
Subject: Re: [PATCH] powerpc/powernv: Select CONFIG_PRINTK to fix build failure
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Michael Neuling <mikey@neuling.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        hegdevasant@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 4:01 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> On Sat, 2014-12-27 at 12:17 -0500, Pranith Kumar wrote:
>> In an allnoconfig we get the following build failure:
>
> An allnoconfig doesn't include CONFIG_PPC_POWERNV? But I think I know what you
> mean.
>
>> arch/powerpc/platforms/built-in.o: In function `.__machine_initcall_powernv_opal_init':
>> opal.c:(.init.text+0x468): undefined reference to `.log_buf_addr_get'
>> opal.c:(.init.text+0x474): undefined reference to `.log_buf_len_get'
>> make: *** [vmlinux] Error 1
>>
>> This happens because powernv requires printk() support. Enable it in the config
>> file.
>
> Sort of. It just requires those two routines. Or is there a stronger
> dependency?
>
> I think the better fix is for those two routines to be defined for
> CONFIG_PRINTK=n, but return NULL and zero respectively.
>
> And the opal code could skip registering the region when they return NULL/zero.
>
> Care to do a couple of patches?
>

Sure, I will give it a try. Thanks for the review!


-- 
Pranith
