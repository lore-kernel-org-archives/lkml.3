Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3KUJOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:14:42 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:35415 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab3KUJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:14:39 -0500
X-Greylist: delayed 771 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 04:14:39 EST
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsweABrOjVJV5qhFPGdsb2JhbAANTItEtUqBMwMBAQEBOIJaAQEBAQIBeAEFCwshFg8JAwIBAgExFAYBDAEHAQGHdwuuaZF3F49rB4QyA5Qwl1yBPw
X-IronPort-AV: E=Sophos;i="4.93,743,1378850400"; 
   d="scan'208";a="659858313"
Message-ID: <528DCFC2.5060005@euromail.se>
Date: Thu, 21 Nov 2013 10:17:54 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Friedrich_Sch=F6ller?= <linux@schoeller.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: Fixed pressure and tool width calculation
 in BCM5974 multitouch driver
References: <1384988052-31898-1-git-send-email-linux@schoeller.se> <1384988052-31898-2-git-send-email-linux@schoeller.se>
In-Reply-To: <1384988052-31898-2-git-send-email-linux@schoeller.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Friedrich,

> Previously ABS_PRESSURE and ABS_TOOL_WIDTH were calculated by looking at the
> size of the first touch in the list reported by the trackpad. This is not
> necessarily the same touch as the one used to perform pointer emulation in the
> input multitouch library (input-mt). By using the sum of the sizes of all
> touches as a basis for this calculation we get more coherent values.
> ---
>  drivers/input/mouse/bcm5974.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)

The input-mt core can be used to output the correct pointer-emulated pressure
based on the individual pressures. Devices capable of measuring pressure should
rather use that method. However, this particular device does not actually
support pressure, and is therefore not applicable.

The legacy pressure code was added a long time ago in order to work with the
only userland option at the time (synaptics X driver). Since then, userland has
matured considerably, with drivers such as input-multitouch, input-evdev,
input-mtrack at your disposal. The only reason the pointer pressure and width
are still in the driver is to remain compatible with old userland.

Thanks,
Henrik

