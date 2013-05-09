Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3EIXvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 19:51:52 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47501 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab3EIXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 19:51:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6uybaWodG_F_=w7fF=w0X008E+HE7PuT=+a4zTG7-ug4A@mail.gmail.com>
References: <CACxGe6uCJde0vw=zcqJOxdiwOJO8bRe00yzs6UDzup5z-jTRbw@mail.gmail.com>
 <CA+55aFwU3w2jiA26fCmF3_i+vpf8TMY+8L5=Oso_uMhZX30DQw@mail.gmail.com> <CACxGe6uybaWodG_F_=w7fF=w0X008E+HE7PuT=+a4zTG7-ug4A@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 10 May 2013 08:51:30 +0900
Message-ID: <CAAVeFuKBn0oyZSJ50pchTwOCsSdyP5ofx3gaf4h_02xYuZDGSg@mail.gmail.com>
Subject: Re: [git pull] GENERIC_GPIO removal
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 3:11 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, May 9, 2013 at 6:08 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Wed, May 8, 2013 at 6:48 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>>
>>> * "git grep '\bGENERIC_GPIO\b'" should return 1 hit in the Chinese
>>>   documentation.
>>
>> That's the oddest command line I've seen in some time.
>>
>> You do realize that "git grep" is perfectly happy to just take the
>> "-w" flag exactly like normal grep?
>
> Hahaha. That's just what Alexandre passed to me. I didn't really think
> much about it.  :-)

/me likes regexps. You should see my workaround to using the -i option.

Thanks for the merge, it clears the path for more GPIO stuff. arch/arc
introduced a new dangling definition of GENERIC_GPIO in -next that now
appears in your tree, the following patch by Vineet takes care of it.
Either you can merge it directly or Vineet will make sure this patch
is in his next pull request.

Alex.

-----8<-----8<-----8<
From: Vineet Gupta <vgupta@synopsys.com>
Date: Wed, 17 Apr 2013 17:33:02 +0530
Subject: [PATCH] ARC: [TB10x] Remove GENERIC_GPIO

This tracks Alexandre Courbot's mainline GPIO rework

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arc/plat-tb10x/Kconfig |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arc/plat-tb10x/Kconfig b/arch/arc/plat-tb10x/Kconfig
index 4e12127..1d34521 100644
--- a/arch/arc/plat-tb10x/Kconfig
+++ b/arch/arc/plat-tb10x/Kconfig
@@ -27,10 +27,3 @@ menuconfig ARC_PLAT_TB10X
          Abilis Systems. TB10x is based on the ARC700 CPU architecture.
          Say Y if you are building a kernel for one of the SOCs in this
          series (e.g. TB100 or TB101). If in doubt say N.
-
-if ARC_PLAT_TB10X
-
-config GENERIC_GPIO
-       def_bool y
-
-endif
