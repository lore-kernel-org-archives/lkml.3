Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab3LFLGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:06:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161015Ab3LFLGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:06:30 -0500
Message-ID: <52A1AF98.7020003@redhat.com>
Date: Fri, 06 Dec 2013 12:06:00 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Oliver Schinagl <oliver@schinagl.nl>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Tejun Heo <tj@kernel.org>, Olliver Schinagl <oliver+list@schinagl.nl>,
        grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        Richard Zhu <r65037@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-3-git-send-email-oliver@schinagl.nl> <20131204123708.GD3158@htj.dyndns.org> <529F2677.3070208@schinagl.nl> <20131204131402.GG3158@htj.dyndns.org> <529F2B41.8090009@schinagl.nl> <20131204132312.GH3158@htj.dyndns.org> <20131206100117.59609a8a@skate> <52A19502.1090409@schinagl.nl>
In-Reply-To: <52A19502.1090409@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/06/2013 10:12 AM, Oliver Schinagl wrote:
>
> On 06-12-13 10:01, Thomas Petazzoni wrote:
>> Dear Tejun Heo,
>>
>> On Wed, 4 Dec 2013 08:23:12 -0500, Tejun Heo wrote:
>>
>>>> But again, point me (for dummies ;) in the right direction and I'll
>>>> work on it with some help.
>>> Richard and Shawn recently worked on ahci_imx.  Can you guys please
>>> talk with each other and figure out what can be done to share as much
>>> as possible among these new platform-specific drivers?  I'd really
>>> like to see the common things factored out as much as possible with
>>> only the actual hardware differences described for each device.
>> Also, please Cc me on such discussions. I have a pending AHCI platform
>> driver for another ARM SoC family. It is very similar to ahci_platform,
>> but needs to do a few more things that are SoC specific (map an
>> additional register area, and do some SoC-specific stuff with them).
>>
>> For the moment, we're left with two approaches:
>>
>>   * Do what Oliver did, where the ahci_<foo> driver will do its own
>>     SoC-specific stuff, and then will register an additional
>>     platform_device to trigger the ->probe() of the generic
>>     ahci_platform driver. I must say I don't really like this solution,
>>     since it involves having two platform_device registered for the same
>>     piece of hardware (one platform_device to trigger the ->probe of
>>     ahci_<foo>, and another one to trigger the ->probe of ahci_platform).
>>
>>   * Duplicate in ahci_<foo> the (relatively small) amount of code that
>>     is present in ahci_platform.
>>
>>  From my point of view, ahci_platform should be turned into a small
>> "library", that provides an API for ahci_<foo> drivers to 1/ do their
>> own custom stuff and 2/ do the common ahci_platform stuff.
>>
>> This way we avoid the registration of two platform_device for the same
>> piece of hardware, and we avoid the duplication of code.
>>
>> Want me to propose a RFC for this idea?
> I've started to do what sdhci does with their pltfrm driver, assuming that's the right approach. Since i'm only dabbling and not always 100% sure what should or shouldn't be done, it may take a little while, but looks promising from my end ;)
>
> So is the sdhci-pltfrm approach the correct one? We still have ahci_* drivers, but ahci_platform.c won't be a driver in the sense that it is now anymore.

Sounds good to me. May I suggest simply adding a new ahci_pltfrm driver for
this and leaving the existing ahci_platform alone? Of course in the end
we want the old ahci_platform to go away, but it is probably best to
introduce the new one in parallel and then port things over 1 by 1
by people who can actually test the port :)

Regards,

Hans
