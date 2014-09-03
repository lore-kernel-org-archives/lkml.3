Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaICJEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:04:32 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64222 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaICJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:04:30 -0400
Message-ID: <5406D98D.7000402@mentor.com>
Date: Wed, 3 Sep 2014 13:04:13 +0400
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
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com> <20140829190129.GZ29327@sirena.org.uk> <5404246E.4090908@de.bosch.com> <20140901101512.GK29327@sirena.org.uk> <54045FA6.70602@mentor.com> <20140901120602.GT29327@sirena.org.uk> <5404680F.3040308@mentor.com> <20140901124947.GU29327@sirena.org.uk>
In-Reply-To: <20140901124947.GU29327@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 04:49 PM, Mark Brown wrote:
> On Mon, Sep 01, 2014 at 04:35:27PM +0400, Dmitry Eremin-Solenikov wrote:
>> On 09/01/2014 04:06 PM, Mark Brown wrote:
>
>>> Please consider my point about making users instantly buggy - it's not
>>> practical to introduce a new field into existing platform data which
>>> needs initialization.  Disallowing the use of 0 as a GPIO seems more
>>> practical here (in that it's something the platform can control with
>>> more reliable coordination).
>
>> I think that this makes other users buggy - those, whose platforms use GPIO
>> numbering starting from 0. IMX platform does. legacy platforms do.
>
> It means that they can't use this feature for these specific GPIOs
> unless someone writes some code to make it happen either by renumbering
> or by adding generic code that provides a way to specify this, it
> doesn't make anything worse than it is already.
>
>> Consider NO_IRQ which is still defined to -1 on ARM platforms. If a device
>> does not have a connected IRQ, it has to explicitly specify -1 instead of
>> specifying logical default 0. Is it so? What is so different with GPIOs and
>> regulators?
>
> As I'm getting fed up of pointing out we can't make existing users buggy
> - we couldn't do it when we added support for enable GPIOs and we can't
> do it now.  Exactly the same problem would occur if adding platform data
> to specify an interrupt where none was previously specified (which is
> why there's a move away from NO_IRQ being -1).
>
> Please, you need to care about other users.

OK, if the question is about other users, should we review all current 
users that do not specify that gpio, change them to pass -1 and then 
allow valid GPIO#0 as a valid ena_gpio? What do you think about a patch
that will warn for one or two releases that ena_gpio == 0 will change 
meaning in a forthcoming feature?


-- 
With best wishes
Dmitry
