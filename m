Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab3KXJky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:40:54 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:58765 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3KXJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:40:52 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnwXAIvIkVJV5qhFPGdsb2JhbAANTIM/vHGBMwMBAQEBOIJaAQEBAQIBaQEOAQULCxQNFgQLCQMCAQIBMRQGDQEFAgEBh3cLCK0tkTYTBI8HB4QzA6wQgT8
X-IronPort-AV: E=Sophos;i="4.93,761,1378850400"; 
   d="scan'208";a="437707710"
Message-ID: <5291CA7B.3080904@euromail.se>
Date: Sun, 24 Nov 2013 10:44:27 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Michele Baldessari <michele@acksyn.org>
CC: jwboyer@fedoraproject.org, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        bugzilla@colorremedies.com, Chris Murphy <chris@cmurf.com>
Subject: Re: small regression: hwmon: (applesmc) Check key count before proceeding
 - 5f4513864304672e6ea9eac60583eeac32e679f2
References: <20131124092359.4241e633@fante.int.rhx>
In-Reply-To: <20131124092359.4241e633@fante.int.rhx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michele,

> The issue Chris has seen in Fedora on one MacBookPro4,1
> (https://bugzilla.redhat.com/show_bug.cgi?id=1033414) is that this
> machine returns a huge number from read_register_count() so now we will
> try to allocate an insane amount of memory and we will barf:
> [    8.603053] applesmc: key count changed from 261 to 1392508929

I was under the impression that this machine was tested before, and that

commit 25f2bd7f5add608c1d1405938f39c96927b275ca
Author: Henrik Rydberg <rydberg@euromail.se>
Date:   Wed Oct 2 19:15:03 2013 +0200

    hwmon: (applesmc) Always read until end of data

resolved this problem? But if the kernel under test is 3.11.8, both patches are
already present... Chris, could you please sched some light on this before
moving on?

Thanks,
Henrik

