Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaESISZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:18:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaESISY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:18:24 -0400
Message-ID: <5379BE43.7090809@redhat.com>
Date: Mon, 19 May 2014 10:18:11 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/3] mfd-core: Don't register supplies from add_device,
 add register_supply_aliases()
References: <1400420953-20705-1-git-send-email-hdegoede@redhat.com> <1400420953-20705-2-git-send-email-hdegoede@redhat.com> <20140519074705.GE2339@lee--X1> <20140519074855.GP25203@opensource.wolfsonmicro.com>
In-Reply-To: <20140519074855.GP25203@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/19/2014 09:48 AM, Charles Keepax wrote:
> On Mon, May 19, 2014 at 08:47:05AM +0100, Lee Jones wrote:
>>> We cannot register supply alias in mfd_add_device before calling
>>> platform_add_device, for 2 reasons:
>>> 1) devm resources may not be registered before the (platform) drivers probe
>>>    method runs
>>> 2) The platform-dev's name must be set before registering the aliases which
>>>    happens from platform_add_device.
>>>
>>> So stop registering supply aliases from mfd_add_device, and add a
>>> mfd_register_supply_aliases helper functions for the cell's plaform driver
>>> probe method to use.
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>  drivers/mfd/mfd-core.c   | 37 +++++++++++++++++++++----------------
>>>  include/linux/mfd/core.h |  6 +++++-
>>>  2 files changed, 26 insertions(+), 17 deletions(-)
>>
>> Change looks reasonable to me, but I'd like to have Mark look over the
>> changes.  If he's okay with them I think it's best for this set to go
>> through the MFD tree as a whole.
> 
> This should already be fixed by this patch:
> 
> mfd: core: Don't use devres functions before device is added

Ah, I did not check next, yes that would fix *half* of the problem,
the other half is that adding aliases uses dev->name (at least for
logging, did not check if it is used for anything else) and that is
not set yet before the device is added.

Basically the moral of the story is that it is a BAD idea to do
anything with a device before it is added. So my proposed series
would replace the "mfd: core: Don't use devres functions before device is added"
patch.

Regards,

Hans
