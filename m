Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbbAFM1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:27:00 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43212 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753340AbbAFM0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:26:55 -0500
Message-ID: <54ABD474.6060403@free-electrons.com>
Date: Tue, 06 Jan 2015 13:26:28 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: core: Add a sanity check on the regulator_
 enable/disable functions
References: <1419614799-5770-1-git-send-email-gregory.clement@free-electrons.com> <1419614799-5770-2-git-send-email-gregory.clement@free-electrons.com> <20141229154030.GJ17800@sirena.org.uk> <54ABC8A2.7090905@free-electrons.com> <20150106120012.GW2634@sirena.org.uk>
In-Reply-To: <20150106120012.GW2634@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 06/01/2015 13:00, Mark Brown wrote:
> On Tue, Jan 06, 2015 at 12:36:02PM +0100, Gregory CLEMENT wrote:
>> Hi Mark,
>>
>> On 29/12/2014 16:40, Mark Brown wrote:
>>> On Fri, Dec 26, 2014 at 06:26:38PM +0100, Gregory CLEMENT wrote:
> 
>>> No, especially in the case of regulator_enable() this is deliberate -
>>> we're trying to ensure that if people are using regulators they're being
>>> careful about it, checking error codes and so on.  I'd really want to
> 
>> OK so at least we should check that the pointer is not NULL before using it
>> and inform the user of it by using a WARNING() or even a BUG() instead of
>> just let the kernel crash latter.
> 
> Just crashing on the NULL is just about as good in terms of
> discoverabilty and any consumer that is assuming NULL is not a valid
> regulator is buggy in any case, any non-error pointer could be a valid
> regulator as far as users are concerned.  
> 
>>> see some persuasive use case for this.  What you're saying here sounds
>>> like the consumer shouldn't be treating the regulator as optional at
>>> all but should instead be using a normal regulator.
> 
>> Being able to deal with NULL pointer in the disable function is convenient
>> and is done in other similar subsystems such as phy or clk for example. Instead
>> of having a check on the NULL pointer in each driver, it seems more logical to
>> do it directly in the disable function.
> 
> This really only applies if it's likely that some thing that always gets
> used if it's there might be missing which isn't the case for regulators,
> it's not at all common to have power supplies that might be missing and

Well the pattern the following pattern is very common in the drivers using
the regulator:

if (!IS_ERR(regulator_pointer)
	regulator_disable(regulator_pointer);


So for me it was a good hint that we can factorize it.

> if they are missing NULL isn't a good way to track them.
> 
> If you're having problems with this and need workarounds in the core to
> make your driver code look OK that sounds like things are working since
> it sounds like the driver code is probably abusing the API here.

I don't _need_ it at all. It was just an improvement but if you don't want it,
I am fine with it.


Thanks,

Gregory




-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
