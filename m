Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaJ2LsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:48:21 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:33453 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384AbaJ2LsT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:48:19 -0400
Subject: Re: [PATCH] of: spi: Export single device registration method and accessors (v2)
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20141029101420.GT18557@sirena.org.uk>
Date: Wed, 29 Oct 2014 13:48:06 +0200
Cc: Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6A3753C0-251A-4645-AD96-CB1D6521175F@antoniou-consulting.com>
References: <1414572037-11306-1-git-send-email-pantelis.antoniou@konsulko.com> <20141029101420.GT18557@sirena.org.uk>
To: Mark Brown <broonie@kernel.org>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Oct 29, 2014, at 12:14 , Mark Brown <broonie@kernel.org> wrote:
> 
> On Wed, Oct 29, 2014 at 10:40:37AM +0200, Pantelis Antoniou wrote:
>> Dynamically inserting spi device nodes requires the use of a single
>> device registration method. Rework and export it.
>> 
>> Methods to lookup a device/master using a device node are added
>> as well, of_find_spi_master_by_node() & of_find_spi_device_by_node().
> 
> Why do we need to do this - I would expect that adding nodes would
> trigger parsing in the same way we normally do it.  Where is the user
> and how does it know that it's handling a SPI node?
> 
> This feels like there is an abstraction problem somewhere, whatever code
> is supposed to use this is going to need to be taught about each
> individual bus which is going to be tedious, I would expect that we'd
> have something like the bus being able to provide a callback which will
> get invoked whenever a new node appears on the parent node for the bus.
> 

There’s a whole patchset that does exactly this. 
Look at "OF: spi: Add OF notifier handler” and you’ll where this is used.

>> Changes since v1:
>> * Brown paper bug with parameter on of_register_spi_device().
> 
> Don't include noise like this in the changelog, put it after --- like
> SubmittingPatches says.  Please also try to keep your CC list sane,
> CCing random people just means that you're increasing the volume of mail
> they have to process.  I'm surprised kernel.org accepts so many CCs.
> 
> I have to say I don't recall ever seeing v1...

All of them are in the CC list for a reason. 

Regards

— Pantelis

