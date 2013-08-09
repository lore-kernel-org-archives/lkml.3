Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968122Ab3HIQeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:34:25 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58748 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968081Ab3HIQeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:34:24 -0400
Message-ID: <520519E7.3020807@ahsoftware.de>
Date: Fri, 09 Aug 2013 18:33:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [rtc-linux] Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time:
 enable HID input processing early
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de> <1375382342-25454-2-git-send-email-holler@ahsoftware.de> <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org> <5204BA2E.8000100@ahsoftware.de> <alpine.LNX.2.00.1308091310490.13089@pobox.suse.cz> <5205170E.9030605@ahsoftware.de>
In-Reply-To: <5205170E.9030605@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.08.2013 18:21, schrieb Alexander Holler:
> I've now also verified if hid-sensor-hub receives an event with
> sensor_hub_raw_event() in the error-path (hid_device_io_stop() called
> and probe() failed), and this still *does* happen. That event (input
> report) doesn't come through hid-sensor-hub to my driver, but I think
> this is because of my call to sensor_hub_remove_callback() which is in
> the error path too.
> So I actually wonder why the input report still is reported from the
> hid-subsystem to hid-sensor-hub, even after I've called
> hid_device_io_stop() and probe() failed.
> Maybe everything is still ok and I just got confused with the somehow
> complicate interactions between the usb- and hid-subsystem,
> hid-sensor-hub (which uses MFD) and rtc-hid-sensor-time.

Adding some more stuff to the confusion: Currently I think it is correct 
that hid-sensor-hub still receives the event, even after 
rtc-hid-sensor-time called hid_device_io_stop() and probe() failed. The 
reason the same reason, why hid-sensor-hub uses mfd, the actual hardware 
device might be shared by different drivers (therfor -hub).

Regards,

Alexander Holler
