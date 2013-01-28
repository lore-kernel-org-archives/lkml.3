Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3A1Pma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:42:30 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:40768 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3A1Pm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:42:28 -0500
X-Greylist: delayed 1452 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 10:42:27 EST
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtVHAH+WBlFV5qjOPGdsb2JhbABEin6zWhcDAQEBATg0gh4BAQQBOhwjBQsIAyElDwUlCgYBE4geCr9rFZAvYQOSWoMyhXuNRg
X-IronPort-AV: E=Sophos;i="4.84,553,1355094000"; 
   d="scan'208";a="194542560"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 28 Jan 2013 16:23:24 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/25] Support of Nexio 42" and new default class for
 hid-multitouch
Message-ID: <20130128152324.GA3481@polaris.bitmath.org>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> finally, I managed to send a new bunch of patches. Sorry for the delay from the
> previous version, but meanwhile, I implemented an automatic regressions tests
> for hid device [1].
> So this series seems pretty big, but it does not break any known devices (I ran
> 40 successful tests for this series)[2].

Thanks for the patches.

> To sum up:
> - Nexio devices were problematic in the sense they use out of range values for
> some of the fields, and consider that the driver won't treat the extra touches
> based on the reported contact count.

Problematic device, but I think we should add a new event function
which gives all values at the same time, since those are already
present in the core. It seems this will solve the current problem as
well as many older workarounds.

> - fortunately, this behavior (relying on contact count) is compatible with all
> the devices I know, which leads to think that this is how the Windows 7/8 driver
> manage to handle such a different bunch of devices.

This is a nice observation. IIRC, we used to rely more on contact
count in the old drivers.

> - thanks to the automatic testing, I was able to fix broken devices
> (Sharp LC-20FE1-W screen 04dd:9681, Sitronix 1403:5001 and Cando 2087:0a02)
> and optimize many others. In order to allow a bisection to be done, I split
> the patches in many different ones, one per device type.

Great tool, thank you Benjamin.

> - finally, I changed the default class in order to handle the new devices in a
> better way.

Old wisdom says differently. ;-)

Thanks,
Henrik
