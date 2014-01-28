Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbaA1PNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:13:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60411 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645AbaA1PND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:13:03 -0500
Date: Tue, 28 Jan 2014 16:12:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
cc: Yufeng Shen <miletus@chromium.org>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [PATCH] HID: usbhid: quirk for CY-TM75 75 inch Touch Overlay
In-Reply-To: <CAN+gG=F3EQ4o99HW3Qid52_Kp1g-yziW1yeNetP5mE9DmEmS2w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1401281612020.3763@pobox.suse.cz>
References: <1390863766-14491-1-git-send-email-miletus@chromium.org> <CAN+gG=F3EQ4o99HW3Qid52_Kp1g-yziW1yeNetP5mE9DmEmS2w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Benjamin Tissoires wrote:

> > There is timeout error during initialization:
> > kernel: [   11.733104] hid-multitouch 0003:1870:0110.0001: usb_submit_urb(ctrl) failed: -1
> > kernel: [   11.734093] hid-multitouch 0003:1870:0110.0001: timeout initializing reports
> >
> > Adding quirk HID_QUIRK_NO_INIT_REPORTS can solve the problem.
> 
> Could you please test the quirk HID_QUIRK_NO_INIT_INPUT_REPORTS instead?
> The patch is perfectly fine, but usually when it fails, only the input
> reports are non-readable, whereas features should. This way, you will
> still get the value of the features, which _may_ be sensible for the
> maxcontact information.
> 
> BTW, HID_QUIRK_NO_INIT_INPUT_REPORTS has been introduced in v3.12 and
> is the default for Win 8 certified devices.

Ah, I have noticed this only after pushing the patch out. Good point.

Yufeng, if you test with HID_QUIRK_NO_INIT_INPUT_REPORTS successfully, 
please let me know, and I'll apply a followup patch on top.
-- 
Jiri Kosina
SUSE Labs
