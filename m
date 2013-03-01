Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3CABfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:35:39 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36046 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3CABfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:35:38 -0500
MIME-Version: 1.0
In-Reply-To: <5108BDDD.60307@ti.com>
References: <1358890049-26981-1-git-send-email-nm@ti.com>
	<5108BDDD.60307@ti.com>
Date: Thu, 28 Feb 2013 19:35:36 -0600
X-Google-Sender-Auth: GBRdMzGO5hb3uRyvpUSuqCFTkl4
Message-ID: <CAGo_u6qZwgGOugh3_F2pFvwM8ZAxU=Rsy7B2Lj6CjO+VG7GwXA@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: remove generated .dtb files on clean
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>, olof@lixom.net
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        l-a <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:29 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:
> Looping RMK, Arnd
Gentle query if we are still interested in this:
https://patchwork.kernel.org/patch/2020831/

Looks like linux master still wont delete the dtbs on make clean etc..
I think leaving the stale dtbs
around could have it's set of user errors.
Regards,
Nishanth Menon

>
>
> On Wednesday 23 January 2013 02:57 AM, Nishanth Menon wrote:
>>
>> commit 5f300acd8ae9f3d4585154370012ffc5c665330f
>> (ARM: 7152/1: distclean: Remove generated .dtb files)
>> ensured that dtbs were cleaned up when they were in
>> arch/arm/boot.
>> However, with the following commit:
>> commit 499cd8298628eeabf0eb5eb6525d4faa0eec80d8
>> (ARM: dt: change .dtb build rules to build in dts directory)
>>
>> make clean now leaves dtbs in arch/arm/boot/dts/
>> untouched. Include dts directory so that clean-files rule
>> from arch/arm/boot/dts/Makefile is invoked when make
>> clean is done.
>>
>> Cc: Dirk Behme <dirk.behme@de.bosch.com>
>> CC: Grant Likely <grant.likely@secretlab.ca>
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>>   arch/arm/boot/Makefile |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/Makefile b/arch/arm/boot/Makefile
>> index abfce28..3837f97 100644
>> --- a/arch/arm/boot/Makefile
>> +++ b/arch/arm/boot/Makefile
>> @@ -115,4 +115,4 @@ i:
>>         $(CONFIG_SHELL) $(srctree)/$(src)/install.sh $(KERNELRELEASE) \
>>         $(obj)/Image System.map "$(INSTALL_PATH)"
>>
>> -subdir-            := bootp compressed
>> +subdir-            := bootp compressed dts
>>
> Seems to be the valid fix for me.
>
> Regards,
> Santosh
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
