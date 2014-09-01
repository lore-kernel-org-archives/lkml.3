Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaIAMfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:35:32 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:53075 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaIAMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:35:31 -0400
Message-ID: <5404680F.3040308@mentor.com>
Date: Mon, 1 Sep 2014 16:35:27 +0400
From: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dirk Behme <dirk.behme@de.bosch.com>, <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com> <20140829190129.GZ29327@sirena.org.uk> <5404246E.4090908@de.bosch.com> <20140901101512.GK29327@sirena.org.uk> <54045FA6.70602@mentor.com> <20140901120602.GT29327@sirena.org.uk>
In-Reply-To: <20140901120602.GT29327@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 04:06 PM, Mark Brown wrote:
> On Mon, Sep 01, 2014 at 03:59:34PM +0400, Dmitry Eremin-Solenikov wrote:
>> On 09/01/2014 02:15 PM, Mark Brown wrote:
>
>>> There's no practical way to deploy that without breaking users - as soon
>>> as you treat 0 as a valid GPIO you make all existing users relying on
>>> the natural behaviour of treating 0 as default instantly buggy which is
>>> not practical.  Really the GPIO API is badly specified here.
>
>> Back in the time before DTS conversion started, the 0 was a correct GPIO
>> number. If somebody wanted to specify that no gpio is provided, he provided
>> -1 as an invalid number. I have the feeling that allowing users to use 0 as
>> 'no gpio' is a mistake. Or the API should be changed
>> to disallow GPIO 0 to exist at all.
>
> Please consider my point about making users instantly buggy - it's not
> practical to introduce a new field into existing platform data which
> needs initialization.  Disallowing the use of 0 as a GPIO seems more
> practical here (in that it's something the platform can control with
> more reliable coordination).

I think that this makes other users buggy - those, whose platforms use 
GPIO numbering starting from 0. IMX platform does. legacy platforms do.

Consider NO_IRQ which is still defined to -1 on ARM platforms. If a 
device does not have a connected IRQ, it has to explicitly specify -1 
instead of specifying logical default 0. Is it so? What is so different 
with GPIOs and regulators?

-- 
With best wishes
Dmitry
