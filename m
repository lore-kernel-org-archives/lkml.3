Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461Ab3FTAzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 20:55:13 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:53373 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab3FTAzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 20:55:11 -0400
MIME-Version: 1.0
In-Reply-To: <201306172334.05626.arnd@arndb.de>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com>
	<2766142.mFu63TyH69@wuerfel>
	<CADApbejV3v11jedq=q9Nz7wyVWVAJp-4vYmAifsPb7UsdVj5zg@mail.gmail.com>
	<201306172334.05626.arnd@arndb.de>
Date: Thu, 20 Jun 2013 08:55:11 +0800
Message-ID: <CADApbeiotgXqX2Y_w8C9zY3mf+MjJmsVS3VBKVdWxYHwNkV2SQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Zhang <zhangwm@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 5:34 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 17 June 2013, Chao Xie wrote:
>> On Fri, Jun 14, 2013 at 8:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Friday 14 June 2013 17:15:33 Chao Xie wrote:
>> >> On Mon, Jun 10, 2013 at 4:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >
>> >> > I guess that is a problem we have on other platforms as well, we should
>> >> > find a generic solution for that. It would be nice to reserve a page
>> >> > in "fixmap" and have common code map the SCU page into that.
>> >> >
>> >>
>> >> So you mean that reserve a page in arch/arm/asm/include/fixmap.h?
>> >
>> > Yes.
>> >
>> >> This reserve will depend on the cpu type beacuse only A9 will have SCU part.
>> >
>> > I think A5 and ARM11MPCore as well.
>> >
>> >> I do not know that in fixmap, the #ifdef is acceptable or not.
>> >
>> > Yes, it is. We don't really use fixmap on ARM for anything other than
>> > kmap_atomic at the moment. Please have a look at the powerpc and x86
>> > implementations.
>> >
>> >> For the common code to map the SCU page, where do you suggest to put it?
>> >
>> > arch/arm/kernel/smp_scu.c.
>> >
>> I think smp_scu.c may not be good place to put the mapping for SCU page.
>> As you know that the fix map will make use of the mapping that set up
>> by vector page.
>> It will make use of top_pmd, and some APIs only provided under arch/arm/mm/.
>> For example
>> get_mem_type: for the pgprot for MT_DEVICE
>> set_top_pte:
>> Is that possible to add a file fixmap.c under arch/arm/mm/? It can
>> including all the fix mapping
>> except highmem. So SCU is one of it.
>
> It's up to Russell, and he probably has an idea where this should be
> going.
>
> Russell, do you think using a fixmap page for the SCU makes sense?
> I'm looking for a method to consolidate the various methods of
> doing early mappings of the SCU for device tree based platforms.
> Where do you think that should be implemented?
>
Hi, Russell

What do you think about above suggestion?

Thanks.


>         Arnd
