Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaE2RUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:20:20 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:60898 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932856AbaE2RUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <53875876.2020001@wwwdotorg.org>
References: <1400888507-11637-1-git-send-email-khilman@linaro.org>
	<53875876.2020001@wwwdotorg.org>
Date: Thu, 29 May 2014 10:20:16 -0700
Message-ID: <CAGa+x84SkGzC3cPCvnZHJEK2uJion=0fowBNdkydjF1GnLLsTw@mail.gmail.com>
Subject: Re: [PATCH] scripts/dtc: pad DTBs to facilitate later modification
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Nicolas Pitre <nico@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Michal Marek <mmarek@suse.cz>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 8:55 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/23/2014 05:41 PM, Kevin Hilman wrote:
>> By default, add some padding to the DT blobs to facilitate later
>> patching.
>>
>> An example need for DTB patching is the need to modifiy the command
>> line on platforms where ATAGS are not (or cannot) be used to pass the
>> commandline.  For example, we do not support a big-endian kernel
>> reading ATAGS from a little-endian u-boot, so the only way to pass a
>> command line in the DT.
>>
>> Also, without ATAG support (or if u-boot was built without
>> CONFIG_INITRD_TAG) the only way to pass an initrd is by adding an
>> initrd= option to command line (in the DT).
>>
>> Therefore, to facilitate adding to the DT command line directly in the
>> DTB, add some padding.
>>
>> Cc: Nicolas Pitre <nico@linaro.org>
>> Cc: Stephen Warren <swarren@wwwdotorg.org>
>> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>> I kinda pulled 64 bytes out of the air here since it's enough to add
>> some common things to the commandline like debug, earlyprink
>> initrd=<addr>,<size>, etc., but I'm certainlly not opposed to more
>> padding.
>
> Conceptually,
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> But I would expect a pad of something like 4KB to be more future-proof.
> U-Boot appears to use 4KB on ARM at least:
>
> ./arch/arm/dts/Makefile:37:DTC_FLAGS += -R 4 -p 0x1000

Great.  As I mentioned above, I'm certainly not opposed to more
padding, and agree that it would be more future proof.  I was simply
being rather conservative in case folks didn't want to see every .dtb
grow by 4k.

I'll wait a bit to see if there are any other opinions, and the respin
with 4k padding.

Kevin
