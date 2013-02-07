Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab3BGXUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:20:00 -0500
Received: from us-mx2.synaptics.com ([12.239.216.76]:28327 "EHLO
	us-mx2.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759492Ab3BGXT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:19:58 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 07 Feb 2013 14:31:45 -0800
Message-ID: <5114369C.4090904@synaptics.com>
Date: Thu, 7 Feb 2013 15:19:56 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 04/05] input: RMI4 F01 device control
References: <1358557965-29065-1-git-send-email-cheiny@synaptics.com> <1358557965-29065-5-git-send-email-cheiny@synaptics.com> <20130131080859.GA4356@core.coreip.homeip.net> <510ADEA2.1080407@synaptics.com>
In-Reply-To: <510ADEA2.1080407@synaptics.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 01:14 PM, Christopher Heiny wrote:
> On 01/31/2013 12:08 AM, Dmitry Torokhov wrote:
>> Hi Chris,
>>
>> On Fri, Jan 18, 2013 at 05:12:44PM -0800, Christopher Heiny wrote:
>>> In addition to the changes described in 0/0 of this patchset, this patch
>>> includes device serialization updated to conform to the latest RMI4
>>> specification.
>>
>> I was looking at the various aspects of the RMI4 patchset, trying to
>> fix the issues that I see, but there is one big issue that I simply do
>> not have time to tackle - the driver is completely broken on big endian
>> architectures due to reliance on bitfileds when exchanging the data with
>> the device.
>
> Grumble.  I brought this up during the original development, but was
> assured that it would work fine per the C language spec.  I'll have to
> revisit that discussion and report back.

OK, after some trivial research it turns out you're right, and I was 
right originally, but let myself be blindsided by bafflegab.  Doh!

As you mentioned, fixing the endian-ness problem is a pretty wide 
ranging change to the way things are done in the driver.  Fortunately 
it's not a structural change to the architecture of the driver.

But because it affects pretty much the whole code (which is actually a 
LOT more code than we're currently submitting - but that unsubmitted 
code will have to be updated concurrently with the submitted code to 
prevent a trainwreck), I'd like to isolate that fix to a single event.

So I propose we get all our other issues worked out, since a bunch of 
them are already in progress.  Once that stuff is stable, my team can do 
one big change to fix the endian bug.  If the code is stable, we can do 
the update on our end pretty quickly.

How does that sound?

					Chris
