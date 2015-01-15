Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbbAOPFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:05:09 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:11473 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbbAOPFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:05:06 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat/jdPryY0=
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/3] input: tsc2007: Add pre-calibration, flipping and rotation
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20150115143855.GD512@earth.universe>
Date: Thu, 15 Jan 2015 16:04:14 +0100
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Belisko Marek <marek.belisko@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-input@vger.kernel.org, Marek Belisko <marek@goldelico.com>,
        Jonathan Richardson <jonathar@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2C4E66DD-1764-4DCA-A58A-78A6986EF7F1@goldelico.com>
References: <1412108254-19234-1-git-send-email-marek@goldelico.com> <1412108254-19234-2-git-send-email-marek@goldelico.com> <CAAfyv36bD9ZratOzr7FkeQde8k-K9XjEjH9gkntm9qewD-cH9g@mail.gmail.com> <20150115005938.GB9134@dtor-ws> <0F9A17C1-9B01-4EE9-BE98-266B8FC02B84@goldelico.com> <20150115143855.GD512@earth.universe>
To: Sebastian Reichel <sre@kernel.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 15.01.2015 um 15:38 schrieb Sebastian Reichel <sre@kernel.org>:

> Hi,
> 
> On Thu, Jan 15, 2015 at 08:36:44AM +0100, Dr. H. Nikolaus Schaller wrote:
>>> 1. Perform conversion in input core rather than individual drivers. I
>>> think we should allocate a new bitmaps for some transformations and have
>>> the code do X/Y flip/clip of the coordinates.
>> 
>> Do you have a suggestion where this should be (I have no clue how
>> the input system works or is structured - we just know how to extend a
>> driver that uses it)?
>> 
>>> 2. Standardize on bindings. We already have of-touchscreen.c doing
>>> rudimentary parsing, we shoudl look into extending it rather than
>>> creating myriad of driver-specific bindings.
>> 
>> Ok, looks reasonable.
> 
> Documentation is in 
> 
> Documentation/devicetree/bindings/input/touchscreen/touchscreen.txt
> 
>>> Also, do we need swap and flip or do we simply need rotation (like the
>>> proposed Broadcom iproc driver has)?
>> 
>> Well, since the DT should describe hardware, there are 3 sets of wires which
>> can have a cross-over: X+ and X-, Y+ and Y-, X and Y.
>> 
>> So IMHO hardware has no “rotation”, just crossover of wires. Rotation is an
>> interpretation of the result of these connections in combination with some
>> panel the touch is glued to and should therefore not be represented in the DT.
>> 
>> As a result we have proposed a scheme without explicit rotation. We specify what
>> coordinates X- and X+ should report at their ends (min, max) because the DT
>> programmer has to specify them anyways. Flipping is a result of defining these
>> coordinates in an ascending or descending way. Only swapping of the X and Y
>> wires can’t be implicitly defined so it has its own property. So the scheme we
>> have proposed tries to optimize the efforts needed to adapt new boards and write
>> DTs and focus the DT on hardware description.
>> 
>> As a bonus we also specify the min and max value to be reported for the touch
>> pressure (Z axis) using the same basic principle.
>> 
>> And it is a pure add-on on top of the existing driver so that it attempts not
>> to break existing device trees.
> 
> from what I can see there are no in-tree-users using any of the
> new properties.

Not yet. But our [patch 2/3] of this series defines the DT entry for the GTA04 devices:

https://lkml.org/lkml/2014/9/30/663

> 
>> Maybe could you accept it as a first step for this specific driver (and let’s do
>> the big standardization work later on)?
> 
> That does not work, since you create an ABI.

Hm. I don’t understand what you mean with creating an ABI?




