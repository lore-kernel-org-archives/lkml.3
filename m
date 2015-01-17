Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbbAQO3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 09:29:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbbAQO3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 09:29:23 -0500
Message-ID: <54BA7197.40301@redhat.com>
Date: Sat, 17 Jan 2015 15:28:39 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
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
References: <1421330978-9694-1-git-send-email-gregory.clement@free-electrons.com> <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com> <54B8C933.7020502@redhat.com> <54B8D97B.3090908@free-electrons.com> <54B8E38A.6020709@redhat.com> <20150116123705.GM3043@sirena.org.uk> <54B9629C.9090800@redhat.com> <20150116202516.GL3856@sirena.org.uk> <54BA21F9.5050408@redhat.com> <20150117131404.GA6414@sirena.org.uk>
In-Reply-To: <20150117131404.GA6414@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 17-01-15 14:14, Mark Brown wrote:
> On Sat, Jan 17, 2015 at 09:48:57AM +0100, Hans de Goede wrote:
>
>> and leave these regulators on, rather then turn them of $random time,
>> because as I've advocated before (see the simplefb thread) there is
>> no simple magic moment when it is right to turn things off, so doing
>> it when userspace starts is more or less as good as any moment, and if
>> it turns out that that is not a good moment, then maybe we need to
>> re-think the turning off in general.
>
> Following your argument to the logical conclusion means we can never
> turn any regualtor off - we always have the risk that there's another
> shared user which is going to get a power bounce if we power down.  More
> directly we'll also get people complaining that we're burning power
> pointlessly on their systems for devices they've not even got drivers
> enabled for.  This powering down is something there's been user demand
> for.

Right, note I'm only advocating to not turn off regulators marked as
regulator-boot-on. I would expect any regulator to have such a
marking to have at least one user with an actual driver. If people decide
to not build that driver, and then complain we can simply tell them to
build the driver ...

Regards,

Hans
