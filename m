Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaJRLoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 07:44:24 -0400
Received: from mail.schreyben.de ([176.9.239.78]:40403 "EHLO mail.schreyben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaJRLoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 07:44:21 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2014 07:44:20 EDT
Message-ID: <5442512F.6000700@schreyben.de>
Date: Sat, 18 Oct 2014 13:38:23 +0200
From: "I. Schrey" <sy@schreyben.de>
Organization: NULL
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/197] 3.12.31-stable review
References: <cover.1413533329.git.jslaby@suse.cz>
In-Reply-To: <cover.1413533329.git.jslaby@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.31 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Jiri,

the commit mentioned below has already been backported to 3.10 stable,
can you please add it to 3.12 stable?

A test build with patch-3.12.31-rc1 and the commit in question
builds and runs fine for me.

Thank you in advance.

Regards
Ingmar

-------- Forwarded message --------
Subject: 	 linux-stable: backport usb related commit to 3.10 and 3.12?
Date: 	 Sat, 23 Aug 2014 13:19:09 +0200
To:
	linux-kernel@vger.kernel.org



Greetings.

On an administered server, I noticed that there's a constant load
around 0.70 when running kernels 3.10 and 3.12, even if
the system is doing nothing, and in single user mode.
Culprit seems to be the process 'khubd'.
No such effect when running kernels 3.4 or 3.14.

I reverse bisected linux-stable and found that the following commit
fixes it for me, for both kernel 3.10 and 3.12:

[08d1dec6f4054e3613f32051d9b149d4203ce0d2] usb:hub set hub->change_bits when over-current happens


Could that commit be backported to the stable 3.10 and 3.12 series?

(Disclaimer: I'm not a programmer, but I'd be happy to help with any testing involved)

Regards
Ingmar

--------------------------------------------------------------------------

$ git diff ac5166bcdb43889a5bd837f5076b78049e1f8bca 08d1dec6f4054e3613f32051d9b149d4203ce0d2
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index c1422a0..babba88 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1147,7 +1147,8 @@ static void hub_activate(struct usb_hub *hub, enum
hub_activation_type type)
                         /* Tell khubd to disconnect the device or
                          * check for a new connection
                          */
-                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
+                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+                           (portstatus & USB_PORT_STAT_OVERCURRENT))
                                 set_bit(port1, hub->change_bits);

                 } else if (portstatus & USB_PORT_STAT_ENABLE) {


-- 

