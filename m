Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbbARP37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 10:29:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbbARP3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 10:29:53 -0500
Message-ID: <54BBD13E.6030901@redhat.com>
Date: Sun, 18 Jan 2015 16:29:02 +0100
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
References: <1421330978-9694-5-git-send-email-gregory.clement@free-electrons.com> <54B8C933.7020502@redhat.com> <54B8D97B.3090908@free-electrons.com> <54B8E38A.6020709@redhat.com> <20150116123705.GM3043@sirena.org.uk> <54B9629C.9090800@redhat.com> <20150116202516.GL3856@sirena.org.uk> <54BA21F9.5050408@redhat.com> <20150117131404.GA6414@sirena.org.uk> <54BA7197.40301@redhat.com> <20150118123531.GA2809@sirena.org.uk>
In-Reply-To: <20150118123531.GA2809@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18-01-15 13:35, Mark Brown wrote:
> On Sat, Jan 17, 2015 at 03:28:39PM +0100, Hans de Goede wrote:
>> On 17-01-15 14:14, Mark Brown wrote:
>
>>> Following your argument to the logical conclusion means we can never
>>> turn any regualtor off - we always have the risk that there's another
>>> shared user which is going to get a power bounce if we power down.  More
>>> directly we'll also get people complaining that we're burning power
>>> pointlessly on their systems for devices they've not even got drivers
>>> enabled for.  This powering down is something there's been user demand
>>> for.
>
>> Right, note I'm only advocating to not turn off regulators marked as
>> regulator-boot-on. I would expect any regulator to have such a
>> marking to have at least one user with an actual driver. If people decide
>> to not build that driver, and then complain we can simply tell them to
>> build the driver ...
>
> Right, but that's not what regulator-boot-on actually means (and I'm not
> sure why you would think it would TBH)

Well, the meaning of regulator-boot-on is not clearly defined really, to
begin we need with fixing that, currently all the bindings file says is:

- regulator-boot-on: bootloader/firmware enabled regulator

One could easily argue that the bootloader likely has a good reason to turn
the regulator on, and that unless there is a specific driver which claims
the regulator and thus knows what to do with it it is best left alone ...

> so this will disrupt existing
> users who are expecting the current behaviour.  We could try adding a
> new property but it doesn't feel very idiomatic for DT which isn't very
> nice.
>
> Telling people not to build the driver doesn't in general work any
> better than telling them to build it in I fear, it seems like it's
> essentially just shuffling things around so people have to change their
> kernel config in a different way to avoid issues.

Regards,

Hans

