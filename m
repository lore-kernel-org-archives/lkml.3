Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3KUJpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:45:44 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:41895 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3KUJpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:45:42 -0500
X-Greylist: delayed 1700 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 04:45:41 EST
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As0eAFzPjVJV5qhFPGdsb2JhbAANTItEtUqBMwMBAQEBOIJaAQEBAQIBMgFFAQULCxgJFg8JAwIBAgExFAYBDAEHAQGHdwuubZF3F49rB4QyA61L
X-IronPort-AV: E=Sophos;i="4.93,743,1378850400"; 
   d="scan'208";a="358652847"
Message-ID: <528DD058.4030803@euromail.se>
Date: Thu, 21 Nov 2013 10:20:24 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        =?ISO-8859-1?Q?Friedrich?= =?ISO-8859-1?Q?_Sch=F6ller?= 
	<linux@schoeller.se>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: Added thumb detection in BCM5974 multitouch
 driver
References: <1384988052-31898-1-git-send-email-linux@schoeller.se> <1384988052-31898-3-git-send-email-linux@schoeller.se> <20131121050549.GC4702@core.coreip.homeip.net>
In-Reply-To: <20131121050549.GC4702@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Nov 20, 2013 at 11:54:12PM +0100, Friedrich Schöller wrote:
>> Trackpads with integrated buttons are hard to use when the driver responds to
>> movements of the thumb that is resting or clicking on the surface of the
>> trackpad. This patch adds rudimentary support to filter out these touch events.
>>
>> The feature can be turned on via sysfs:
>> 	/sys/class/input/input[0-9]+/thumb_ignore:
>> 		Enables thumb detection
>> 		Values: 0/1
>> 	/sys/class/input/input[0-9]+/thumb_ratio_on:
>> 		When the ratio of ABS_MT_TOUCH_MINOR / ABS_MT_TOUCH_MAJOR
>> 		times 100 is smaller than this value the touch qualifies
>> 		as a thumb.
>> 	/sys/class/input/input[0-9]+/thumb_ratio_off:
>> 		When the ratio of ABS_MT_TOUCH_MINOR / ABS_MT_TOUCH_MAJOR
>> 		times 100 is bigger than this value the touch no longer
>> 		qualifies as a thumb.
>> 	/sys/class/input/input[0-9]+/thumb_y_on:
>> 		When ABS_MT_POSITION_Y is bigger than this value the touch
>> 		qualifies as a thumb.
>> 	/sys/class/input/input[0-9]+/thumb_y_off:
>> 		When ABS_MT_POSITION_Y is smaller than this value the touch
>> 		no longer qualifies as a thumb.
> 
> I'd rather this been implemented in userspace (synaptics and/or evdev X
> drivers).

And it has been in userland since at least 2008. It can be found in
input-synaptics, input-multitouch, input-mtrack, possibly more places.

Thanks,
Henrik

