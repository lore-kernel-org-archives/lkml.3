Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaBQRt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:49:26 -0500
Received: from 185-25-241-215.rdns.posilan.com ([185.25.241.215]:37404 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753108AbaBQRtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:49:23 -0500
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2014 12:49:23 EST
Message-ID: <530249EF.4060803@codethink.co.uk>
Date: Mon, 17 Feb 2014 17:42:07 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, linux-kernel@lists.codethink.co.uk,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH] of_mdio: fix phy interrupt passing
References: <1392654580-3706-1-git-send-email-ben.dooks@codethink.co.uk> <CAGVrzcYeuTA0Yd5YyOTuWQfnwLw9zP87MaYJOLwprZRCtvuaXw@mail.gmail.com>
In-Reply-To: <CAGVrzcYeuTA0Yd5YyOTuWQfnwLw9zP87MaYJOLwprZRCtvuaXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/14 17:26, Florian Fainelli wrote:
> Hi Ben,
>
> 2014-02-17 8:29 GMT-08:00 Ben Dooks <ben.dooks@codethink.co.uk>:
>> The of_mdiobus_register_phy() is not setting phy->irq this causing
>> some drivers to incorrectly assume that the PHY does not have an
>> IRQ associated with it or install an interrupt handler for the
>> PHY.
>>
>> Simplify the code setting irq and set the phy->irq at the same
>> time so that the case if mdio->irq is not NULL is easier to read.
>
> The real bug fix, which is not properly explained here, is that
> irq_of_parse_and_map() should return values > 0 when the interrupt is
> valid, so this makes me wonder why we are not propagating the return
> value from irq_of_parse_and_map() in case the call to
> of_irq_parse_one() does return something non-zero?

No, the first issue is phy->dev never gets set, which causes the
issue. The cleanup was added as it seemed easier to put it in with
this.

I think phy->irq is already initialised to PHY_POLL and thus there
is no need to set phy->irq if the irq_of_parse_and_map() fails.

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
