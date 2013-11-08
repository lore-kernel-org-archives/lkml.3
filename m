Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab3KHSRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:17:33 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59565 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757619Ab3KHSRb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:17:31 -0500
Subject: Re: common location for devicetree files
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131108181351.GF10335@titan.lakedaemon.net>
Date: Fri, 8 Nov 2013 12:17:30 -0600
Cc: devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2274FB81-099B-4206-8332-70E9824FFF2F@codeaurora.org>
References: <1438803E-C904-428B-B042-891978BC15DF@codeaurora.org> <20131108165255.GA32668@titan.lakedaemon.net> <5957C301-9698-45B0-BFED-749DE79D0A74@codeaurora.org> <20131108181351.GF10335@titan.lakedaemon.net>
To: Jason Cooper <jason@lakedaemon.net>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 8, 2013, at 12:13 PM, Jason Cooper wrote:

> On Fri, Nov 08, 2013 at 11:59:56AM -0600, Kumar Gala wrote:
>> 
>> On Nov 8, 2013, at 10:52 AM, Jason Cooper wrote:
>> 
>>> On Thu, Nov 07, 2013 at 05:21:58PM -0600, Kumar Gala wrote:
>>>> As we start having more sharing of device trees between architectures
>>>> (arm & arm64, arm & powerpc, guessing maybe mips & arm) we need dts to
>>>> live in location that 
>>>> 
>>>> I was wondering what people felt about doing:
>>>> 
>>>> 	arch/dts/<VENDOR>/
>>>> 
>>>> as a common location that could be shared.  I'm up for other
>>>> suggestions.
>>> 
>>> What do we really need to do before the move?  Should all arch dts files
>>> be able to #include from any arch?  What's the minimum churn needed to
>>> accomplish that?  Maybe just move the needed bits to arch/dts/include/ ?
>>> 
>>> I'm not real keen on separating by vendor.  For example, us mvebu folks
>>> would probably miss useful/duplicated effort in another vendor's
>>> subdirectory.  Which was the whole reason for moving driver code out of
>>> machine directories to begin with.
>> 
>> 
>> Can you explain that further, what would you miss from other vendors.
>> All the patches should still be going via devicetree ML.
> 
> I was simply applying the same logic used to justify moving all of the
> driver code out of arch/arm/.  Once that happened, a lot of patterns
> emerged and we have things like common clock now.  Yet all of this code
> (originally under arch/arm) was submitted to the same ML.
> 
> iow, there's a difference between being on the same high-traffic
> mailinglist where people are filtering out just what they need, and
> being in the same subdirectory, right next to three other
> implementations of the same code (I exaggerate, but the point remains).
> It's a lot easier to spot similar implementations when they are all
> congregated under one directory.
> 
> How many boards are using the same PMIC across vendors?  Would it make
> sense to have a tps6905.dtsi they could all include?  Flash chips?  I'm
> just asking.
> 
> My gut is that having separate vendor directories would lead to
> balkanization.  That might not be a problem, but it's worth considering.
> 
> thx,
> 
> Jason.

I get the point, just not sure how else to sort the 800+ .dts{i} files that we have in the kernel tree right now.

I think common patterns have to be looked at by various maintainers.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

