Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbbAPTOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:14:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbbAPTOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:14:18 -0500
Message-ID: <54B962E0.9060504@redhat.com>
Date: Fri, 16 Jan 2015 20:13:36 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
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
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com> <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com> <54B8C933.7020502@redhat.com> <54B8D97B.3090908@free-electrons.com> <54B8E38A.6020709@redhat.com> <20150116123705.GM3043@sirena.org.uk> <54B91FB4.5080707@free-electrons.com> <20150116153451.GA3856@sirena.org.uk>
In-Reply-To: <20150116153451.GA3856@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 16-01-15 16:34, Mark Brown wrote:
> On Fri, Jan 16, 2015 at 03:27:00PM +0100, Gregory CLEMENT wrote:
>> On 16/01/2015 13:37, Mark Brown wrote:
>
>>> regulator-always-on is a bit fuzzy for suspend, if the regulator has
>>> suspend control it'll kick in - it's really about the Linux refcounting
>>> while it's running.  What's more concerning here is that the quick
>>> sample of the regulators flagged as always on like the above that I
>>> looked at in the patch don't seem to have any enable control in the DT
>>> so this will have absolutely no effect.
>
>> Actually the reg_sata[0-4] are controlled by gpio, so there is a mean
>> to enable/disable them. For the reg_5v_sata[0-4] and reg_12v_sata[0-4]
>> they depend on their respective reg_sata and I just propagated the
>> regulator-always-on, this was maybe a mistake.
>
> It certainly makes everything confusing if you have control related
> stuff on regulators that are not directly controllable.
>
>>>> It is probably a good idea to use regulator-boot-on and
>>>> then test things this way, and if that works use
>>>> regulator-boot-on.
>
>>> No, it's unlikely that boot-on makes sense here - it's there for cases
>>> where we can't read back the hardware state at power on.  Generally
>>> drivers should work regardless of the initial state of the regulator
>>> (and modular drivers will actually break if they try to rely on boot-on
>>> since we clean up unused regulators at boot).
>
>> As pointed by Hans my concern here was be sure that during boot the disk
>> are not power off. In this case which property would be accurate?
>
> None, the core won't do anything with the regulator until the end of
> init anyway.

That us simply not true, see my other mail gpio enabled regulators will
be turned off *at register time* unless they have regulator-boot-on set.

Regards,

Hans

