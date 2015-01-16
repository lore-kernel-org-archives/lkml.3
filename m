Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbbAPO1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:27:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34585 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750703AbbAPO1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:27:34 -0500
Message-ID: <54B91FB4.5080707@free-electrons.com>
Date: Fri, 16 Jan 2015 15:27:00 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Hans de Goede <hdegoede@redhat.com>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 4/4] ARM: mvebu: Armada 385 GP: Add regulators to the
 SATA port
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com> <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com> <54B8C933.7020502@redhat.com> <54B8D97B.3090908@free-electrons.com> <54B8E38A.6020709@redhat.com> <20150116123705.GM3043@sirena.org.uk>
In-Reply-To: <20150116123705.GM3043@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark and Hans,

On 16/01/2015 13:37, Mark Brown wrote:
> On Fri, Jan 16, 2015 at 11:10:18AM +0100, Hans de Goede wrote:
>> On 16-01-15 10:27, Gregory CLEMENT wrote:
> 
>>>>> +	reg_sata0: pwr-sata0 {
>>>>> +		compatible = "regulator-fixed";
>>>>> +		regulator-name = "pwr_en_sata0";
>>>>> +		enable-active-high;
>>>>> +		regulator-always-on;
> 
>>>> done, but we're not using a power on delay anyways.
> 
>>> But if regulator-always-on prevent to switch it off in
>>> suspend then yes using regulator-boot-on is better.
> 
>> AFAIK regulator-always-on means exactly that and thus likely
>> is not what you want. As for using regulator-off-in-suspend
>> that is not necessary as the suspend method for the acpi
>> driver will already turn it off.
> 
> regulator-always-on is a bit fuzzy for suspend, if the regulator has
> suspend control it'll kick in - it's really about the Linux refcounting
> while it's running.  What's more concerning here is that the quick
> sample of the regulators flagged as always on like the above that I
> looked at in the patch don't seem to have any enable control in the DT
> so this will have absolutely no effect.

Actually the reg_sata[0-4] are controlled by gpio, so there is a mean
to enable/disable them. For the reg_5v_sata[0-4] and reg_12v_sata[0-4]
they depend on their respective reg_sata and I just propagated the
regulator-always-on, this was maybe a mistake.

> 
>> It is probably a good idea to use regulator-boot-on and
>> then test things this way, and if that works use
>> regulator-boot-on.
> 
> No, it's unlikely that boot-on makes sense here - it's there for cases
> where we can't read back the hardware state at power on.  Generally
> drivers should work regardless of the initial state of the regulator
> (and modular drivers will actually break if they try to rely on boot-on
> since we clean up unused regulators at boot).

As pointed by Hans my concern here was be sure that during boot the disk
are not power off. In this case which property would be accurate?


Thanks,

Gregory

-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
