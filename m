Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3FTJWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:22:11 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:55161 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3FTJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130619182354.GD1403@sirena.org.uk>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
	<1369032694-13183-3-git-send-email-ks.giri@samsung.com>
	<20130619182354.GD1403@sirena.org.uk>
Date: Thu, 20 Jun 2013 14:52:07 +0530
Message-ID: <CAKrE-KciiPe5Zx7ggxzh=x0xY0xGDhX+=Lt7aL-EgkxinO214w@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] spi: s3c64xx: Added provision for dedicated cs pin
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:53 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, May 20, 2013 at 12:21:33PM +0530, Girish K S wrote:
>> From: Girish K S <girishks2000@gmail.com>
>>
>> The existing driver supports gpio based /cs signal.
>> For controller's that have one device per controller,
>> the slave device's /cs signal might be internally controlled
>> by the chip select bit of slave select register. They are not
>> externally asserted/deasserted using gpio pin.
>>
>> This patch adds support for controllers with dedicated /cs pin.
>> if "cs-gpio" property doesnt exist in a spi dts node, the controller
>> would treat the /cs pin as dedicated.
>
> This breaks SPI operation on my s3c64xx based system since...
>
>>       if (pdev->dev.of_node) {
>> +             if (of_find_property(pdev->dev.of_node, "cs-gpio", NULL))
>> +                     sdd->cs_gpio = true;
>> +
>>               ret = of_alias_get_id(pdev->dev.of_node, "spi");
>>               if (ret < 0) {
>>                       dev_err(&pdev->dev, "failed to get alias id, errno %d\n",
>
> sdd->cs_gpio is only set to true by this code so if you're using a board
> file then the GPIO will be ignored.

Reversing the default assignment for "sdd->cs_gpio" and the following
"if condition" shall handle both dt and non-dt case. Will do it and
resubmit only this patch in the series.
