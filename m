Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3H2SCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:02:35 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45997 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3H2SCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:02:33 -0400
Message-ID: <521F8CB3.5060407@gmail.com>
Date: Thu, 29 Aug 2013 20:02:27 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Mark Brown <broonie@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>, liam.r.girdwood@intel.com
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
References: <20130828113459.48ecbb34@armhf> <521DCD33.2070008@gmail.com> <20130828121943.1c8327ca@skate> <521DD057.4040208@gmail.com> <20130829161217.GK10783@sirena.org.uk> <20130829163358.GS6617@n2100.arm.linux.org.uk> <20130829171210.GM10783@sirena.org.uk>
In-Reply-To: <20130829171210.GM10783@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/13 19:12, Mark Brown wrote:
> On Thu, Aug 29, 2013 at 05:33:58PM +0100, Russell King - ARM Linux wrote:
>> On Thu, Aug 29, 2013 at 05:12:17PM +0100, Mark Brown wrote:
>>> On Wed, Aug 28, 2013 at 12:26:31PM +0200, Sebastian Hesselbarth wrote:
>
>>>> Also, we'll need to distinguish between the different audio controllers
>>>> on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
>>>> base passed.
>
>>> Why is this required - ideally this would have been mentioned in some of
>>> the previous reviews...
>
>> I've mentioned the differences between the blocks to you repeatedly in
>> our massive thread, including that some contain the block with different
>
> You have described some additional features which will require
> additional driver support.  I would expect that the device tree bindings
> for these features would be added as the features are added and the DTS
> files updated, for example by listing additional compatible strings if
> that was the binding update, as is the normal practice.  Obviously any
> hardware which is not compatible with the current binding should not be
> being registered using the current binding.
>
> It is not clear from the above comment by Sebastian if he is referring
> to the same set of hardware differences or something new - doing things
> based on device address is highly unusual, it sounds like something to
> do with the integration into the SoC rather than to do with the IP.
>

Mark,

it is referring the same differences Russell already mentioned. But I
already came to the conclusion, that we don't need the information in
the binding. For example, if you use that controller on Dove and you
hook it up for SPDIF-in (which it hasn't), than I consider this a
DT bug. No need to double-check that in the driver. From that p-o-v,
please just let the current binding as is.

Thomas Petazzoni mentioned earlier, that the _usual_ procedure to
name the compatibles is to pick the SoC that the IP appeared in first.
But I am also fine with "marvell,mvebu-audio" and adding compatibles
for dove or kirkwood _if_ we will ever need them.

Please, just stop fighting over this again - it is not getting anything
any further.

Sebastian
