Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab3IVRRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:17:20 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.192.1]:56272 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197Ab3IVRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:17:19 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Sep 2013 13:17:19 EDT
Message-ID: <523F2390.5030702@math.tu-berlin.de>
Date: Sun, 22 Sep 2013 19:06:24 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
Subject: i835GM flicker on panning
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee> <alpine.SOC.1.00.1309211825490.9193@math.ut.ee> <4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
In-Reply-To: <4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, hi Daniel,

there is still an issue with flicker on panning with the 835GM chipset. 
As already explained, the flicker only appears if the panning position 
satisfies certain alignment constraints, in specific. As long as the 
plane pointer is aligned to 64 byte boundaries, everything works correctly.

I tried now to add a parameter to the kernel to adjust the watermark 
level of the chipset and see whether this makes any difference with 
regards to the flicker. However, it does not. It seems that the trouble 
is not there.

However, I noticed something interesting: If I use a non-native mode of 
the display, i.e. enable the scaling feature of the DVO, everything 
works, and no flicker ever appears. However, in these situations the 
resolution is also lower than that of the native display, and hence the 
issue may also be related to the PLL clock.

I also noticed that if I invert the display, i.e. use the rotation 
feature, even in the native resolution, nothing flickers, though panning 
is rather slow.

Does this somehow ring a bell? Can I somehow force the driver to use the 
same logic for the regular display as for the inverted display to avoid 
the flicker?

Any help would be appreciated.

Greetings,
	Thomas

