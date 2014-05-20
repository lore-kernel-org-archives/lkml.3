Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaETOmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:42:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbaETOmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:42:10 -0400
Date: Tue, 20 May 2014 16:42:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Harald Brinkmann <hbrinkmann@braincalibration.de>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] HID: quirk for Saitek RAT7 and MMO7 mices' mode
 button
In-Reply-To: <53335A6D.6050608@braincalibration.de>
Message-ID: <alpine.LNX.2.00.1405201642010.1615@pobox.suse.cz>
References: <53335A6D.6050608@braincalibration.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014, Harald Brinkmann wrote:

> Hi all,
> 
> and thanks for the pointers, Benjamin. I finally had some time to fix it.
> - Moved the quirk to hid-saitek
> - Tracking the mode and setting only one bit on a mode change in .raw_event
> - Generating instant release events for the button in .event
> 
> One question:
> Is there any way other than loading hid-saitek before hid-generic to ensure
> the device is claimed by the more specific driver?

Hi Harald,

you need to add the VID/PIDs you are adding to saitek_devices[] also to 
hid_have_special_driver[].

Once you do that, the binding will work correctly.

Please respin the patch with this change and resubmit.

-- 
Jiri Kosina
SUSE Labs
