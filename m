Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3KUM4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:56:36 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:44477 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3KUM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:56:34 -0500
X-Greylist: delayed 1279 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2013 07:56:33 EST
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQYAAr9jVJV5qhFPGdsb2JhbAANTIM/vU+BNwMBAQEBOIJaAQEBAQIBAQJ1BgsLIRYPCQMCAQIBFhsUBgEMCAEBh3cLCK5kkXYXj3KEMgOVQ5gI
X-IronPort-AV: E=Sophos;i="4.93,743,1378850400"; 
   d="scan'208";a="358921190"
Message-ID: <528DFEC6.3050705@euromail.se>
Date: Thu, 21 Nov 2013 13:38:30 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fixes for multitouch / generic gamepads interaction
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> I have been reported recently a problem with the Sixaxis controller
> (http://www.spinics.net/lists/linux-input/msg28098.html).
> The root of the problem comes from hid-input, which maps unknown axis to
> ABS_MISC. However, when an event code is already in use, hid-input uses the one
> after, leading to uses of ABS_MISC + N, where N is the number of unknown axis.

Yes, and clearly we should not do that. :-)

> We are encountering a problem with the multitouch protocol here because if a
> device has more than 7 unknown axis (which is the case for the PS3 Sixaxis
> controller), then the unknown axis get maps to ABS_MT_SLOT and beyond.
> 
> This infers two problems:
> - the axis currently mapped on ABS_MT_SLOT is a special case in the kernel,
> and it is not updated
> - the axis after ABS_MT_SLOT are not filtered anymore, as the kernel things
> the device is using a multitouch protocol A.

The problem is generic, and ABS_MT_SLOT just happens to be the first value that
the hid logic hits. When sevenaxis comes out, we have to do this all over again.

> The patch 0001 solves the first problem, whereas the patches 0002 and 0003
> fix the second. Bonus point: the userspace is now correctly notified that one of
> the multitouch protocols is in used, so it does not have to rely on bad designed
> heuristics.

The bad heuristics are lines 918 and onwards in hid-input.c. I am sure we can
come up with a way to allocate those axes in a much less fragile way.

Thanks,
Henrik

