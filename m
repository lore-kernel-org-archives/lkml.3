Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaEOHOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:14:48 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33706 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaEOHOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:14:45 -0400
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <53735D88.5090108@mycable.de>
Date: Thu, 15 May 2014 00:14:37 -0700
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Guenter Roeck <linux@roeck-us.net>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 7bit
Message-Id: <4E9BC0D6-C8A7-4967-8F98-82D7D93B9667@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com> <1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com> <20140514100856.5198DC4153D@trevor.secretlab.ca> <53735D88.5090108@mycable.de>
To: Michael Stickel <ms@mycable.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On May 14, 2014, at 5:11 AM, Michael Stickel wrote:

> Hi Grant,
> 
> Am 14.05.2014 12:08, schrieb Grant Likely:
>> More generally I am concerned about whether or not overlays
>> will introduce corner cases that can never be handled correctly,
>> particularly in how multiple overlays will get handled. I want to see
>> very clear rules on what happens when multiple overlays are applied, and
>> then removed again. Is it possible to remove overlays out of order? If
>> so, what are the conditions that would not be allowed?
> 
> Yes, it is possible that an overlay depends on another.
> 
> The problem is not, that an overlay is removed other overlays depend on,
> but that nodes of an overlay may depend on the to-be-removed overlay and
> the resulting devicetree can become inconsistent.
> 
> 
> I have an SPI Bus with two slaves. The second slave is used only on one
> of our boards. That is why we split the overlays the following way:
> 
> xxxx_spi1.dts:
>  Pinmux for SPI-Bus and activation of spi-controller.
>  Pinmux for CS0 and definition of first slave.
> 
> xxxx_spi1_cs1:
>  Pinmux for CS1 and definition of second slave.
> 
> When the overlay for the bus is removed, the overlays for the second
> slave does not make any sense anymore.
> 
> It is even worse in a scenario we have with a test board.
> One of the slaves is an spi-io-controller with a few bitbanging i2c
> masters. In an extreme case, each component is defined in a separate
> overlay and only the overlay with the master is removed. I know, that
> this is completely sick. The devices are removed cleanly because of the
> device dependency.
> 

Well, shouldn't you be reverting the overlays in reverse sequence?

As I see it, when proper subtree tracking is implemented this use case 
(of removing #0 before #1) will not be allowed.

What is your ideal scenario for this use case?

> Michael
> 

Regards

-- Pantelis

