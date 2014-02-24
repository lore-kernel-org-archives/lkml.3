Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaBXRct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:32:49 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:63459 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaBXRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:32:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140221222947.GB13233@quad.lixom.net>
References: <CAEPRUYpCVpV7HwuO6c95ybk3yp1teJgW-9qwyHnjKbs03C9bgQ@mail.gmail.com>
	<20140221222947.GB13233@quad.lixom.net>
Date: Mon, 24 Feb 2014 09:32:47 -0800
Message-ID: <CAEPRUYqnGwRCzGPP8ouEguj8gWrJKic7XyNHu+B_aJ=K0=MZYg@mail.gmail.com>
Subject: Re: [GIT PULL] bcm pinctrl rename
From: Christian Daudt <bcm@fixthebug.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Matt Porter <mporter@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sherman Yin <syin@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 2:29 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Feb 12, 2014 at 09:20:13AM -0800, Christian Daudt wrote:
>> The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:
>>
>>   Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)
>>
>> are available in the git repository at:
>>
>>   git://github.com/broadcom/bcm11351.git tags/bcm-for-3.14-pinctrl-rename
>>
>> for you to fetch changes up to f5310a1712b68c7f83539fce6ebbfb6f0f510f5b:
>>
>>   Update dtsi with new pinctrl compatible string (2014-02-12 09:06:53 -0800)
>>
>> ----------------------------------------------------------------
>> Renaming pinctrl code to keep in line with rest of bcm mobile
>>
>> Given that this driver has been in the works for a while, it
>> was written prior to the code standardizing on bcm-based naming.
>> this patchset brings it in line with the remainder of the code.
>>
>> ----------------------------------------------------------------
>> Sherman Yin (4):
>>       pinctrl: Rename Broadcom Capri pinctrl binding
>>       pinctrl: Rename Broadcom Capri pinctrl driver
>>       Update bcm_defconfig with new pinctrl CONFIG
>>       Update dtsi with new pinctrl compatible string
>
> Hi,
>
> (As per irc discussion). The rename isn't the right thing to do at this
> time in the release, but the binding needs to be tweaked before it ships
> in a full release, or we'll always need to live with it.
>
> So, I'll be happy to take the bindings piece and the dtsi piece (and the
> small edit to the driver to change the compatible string match table),
> but the file rename and Kconfig entry edit is 3.15 material.
>
> Please send new pull request with just that (or, if you prefer, just send the
> patches and we can apply them too).
>
>
> -Olof

Ok, I have this ready to go, just need an ack for this patch (which
will replace "pinctrl: Rename Broadcom Capri pinctrl driver"):
Subject: [PATCH] pinctrl: refer to updated dt binding string.

Bring the driver in line with the bcm-based dt name for pinctrl.
This is being done to keep consistency with other Broadcom mobile
SoC drivers.

Signed-off-by: Christian Daudt <bcm@fixthebug.org>

diff --git a/drivers/pinctrl/pinctrl-capri.c b/drivers/pinctrl/pinctrl-capri.c
index 4669c53..eb25002 100644
--- a/drivers/pinctrl/pinctrl-capri.c
+++ b/drivers/pinctrl/pinctrl-capri.c
@@ -1435,7 +1435,7 @@ int __init capri_pinctrl_probe(struct
platform_device *pdev)
 }

 static struct of_device_id capri_pinctrl_of_match[] = {
-       { .compatible = "brcm,capri-pinctrl", },
+       { .compatible = "brcm,bcm11351-pinctrl", },
        { },
 };

-- 
1.8.3.2


Thanks,
   csd
