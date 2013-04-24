Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3DXVCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:02:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:32794 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3DXVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:02:31 -0400
Message-ID: <51784850.5090809@infradead.org>
Date: Wed, 24 Apr 2013 14:02:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH] re-order CONFIG_EXPERT options to fix menuconfig display
References: <1366652378-29558-1-git-send-email-vapier@gentoo.org> <20130424130443.7f78a5d78a59d7ed9968cc90@linux-foundation.org>
In-Reply-To: <20130424130443.7f78a5d78a59d7ed9968cc90@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/13 13:04, Andrew Morton wrote:
> On Mon, 22 Apr 2013 13:39:38 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
> 
>> The kconfig language requires that dependent options all follow the
>> menuconfig symbol in order to be collapsed below it.  Recently some
>> hidden options were added below the EXPERT menuconfig, but did not
>> depend on EXPERT (because hidden options can't).  This broke the
>> display.  So re-order all these options, and while we're here stick
>> the PCI quirks under the EXPERT menu (since it isn't sitting with
>> any related options).
>>
>> Before this commit, we get:
>> 	[*] Configure standard kernel features (expert users)  --->
>> 	[ ] Sysctl syscall support
>> 	[*] Load all symbols for debugging/ksymoops
>> 	...
>> 	[ ] Embedded system
>>
>> Now we get the older (and correct) behavior:
>> 	[*] Configure standard kernel features (expert users)  --->
>> 	[ ] Embedded system
>> And if you go into the expert menu you get the expert options:
>> 	[ ] Sysctl syscall support
>> 	[*] Load all symbols for debugging/ksymoops
>> 	...
>>
> 
> This doesn't work as advertised when I graft it on top of
> http://ozlabs.org/~akpm/mmots/broken-out/init-kconfig-make-expert-as-config-instead-of-menuconfig.patch
> (generally, assuming that next==mainline when we're at -rc8 is a low
> percentage move).
> 
> I think I'll drop
> init-kconfig-make-expert-as-config-instead-of-menuconfig.patch and take
> this one, but could everyone please review everything?

I agree, that's the right thing to do.

Zhangwei's patch description should have been a big hint to me:

There don't have any EXPERT menu guard, and no config item is included in
EXPERT menu, so change it as a config, not menu.

but that should not have been the case.


thanks,
-- 
~Randy
