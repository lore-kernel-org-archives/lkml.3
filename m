Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab3BKLZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 06:25:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:24915 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab3BKLZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 06:25:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,641,1355126400"; 
   d="scan'208";a="260999088"
Date: Mon, 11 Feb 2013 13:29:45 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid driver transport cleanup
Message-ID: <20130211112945.GD20771@intel.com>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <20130211101336.GA20771@intel.com>
 <CAN+gG=GJH-jTFE5OEsme57RzN_L1_gQMAD9Dy2=NXZdDOYCUxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=GJH-jTFE5OEsme57RzN_L1_gQMAD9Dy2=NXZdDOYCUxA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 12:19:13PM +0100, Benjamin Tissoires wrote:
> On Mon, Feb 11, 2013 at 11:13 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Fri, Feb 08, 2013 at 03:37:29PM +0100, Benjamin Tissoires wrote:
> >> so, here is the hid drivers cleanup. The aim is to remove as much as possible
> >> direct calls to usbhid for hid drivers. Thus, other transport layers can use
> >> the existing hid drivers (like I2C or uhid).
> >
> > We also found out that there is a dependency to usbhid in many of the
> > drivers, especially in sensor-hub which caused the system crash while the
> > driver tried to transmit over USB even though it was behind I2C.
> >
> > Your series fixes that nicely :)
> >
> > You can add,
> >
> > Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > for the whole series and in addition,
> >
> > Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > for the sensor-hub part (HID over I2C). I have few more patches to the
> > sensor-hub myself and I'm going to rebase them on top of this series.
> 
> Thanks Mika for reviewing.
> 
> I just wanted to warn you that the HID over I2C part is still lacking
> the support of requests through hid_hw_request(). So the functions
> sensor_hub_set_feature(), sensor_hub_get_feature() and
> sensor_hub_input_attr_get_raw_value() won't work, in a silently way
> :(.

OK.

> I started writing the patch but stopped at some point due to lack of
> ways to test it.

Well, I have the HW here so if you have something please send to me. I can
test it.
