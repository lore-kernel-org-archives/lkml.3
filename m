Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab3BKRMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:12:40 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:37544 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3BKRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:12:37 -0500
MIME-Version: 1.0
In-Reply-To: <4FA419E87744DF4DAECD5BCE1214B7A91E00EB72@ORSMSX108.amr.corp.intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
	<1360578679-7029-2-git-send-email-mika.westerberg@linux.intel.com>
	<4FA419E87744DF4DAECD5BCE1214B7A91E00EB72@ORSMSX108.amr.corp.intel.com>
Date: Mon, 11 Feb 2013 18:12:35 +0100
Message-ID: <CAN+gG=GKzpWqAwJbFtMBt4DMG-4enXbwYPVF1VJG5Y=w9aQ0vw@mail.gmail.com>
Subject: Re: [PATCH 2/3] HID: sensor-hub: get rid of unused
 sensor_hub_grabbed_usages[] table
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 4:53 PM, Pandruvada, Srinivas
<srinivas.pandruvada@intel.com> wrote:
> This was added to load sensor hub driver on USB plug in without explicit modprobe.
> But with last few changes to remove vendor and product id, we need to do modprobe this driver.
> So removal is OK.

I just figure your comment out: the change does not seem to have
anything to do with hotplugging. .usage_table is used to decide which
HID reports to forwards to the .event() callback, and NULL means all
events. So even if it was in use, there are no functional changes.

Thanks to the changes to remove the vendor id and product id, you
shouldn't have to manually modprobe the driver as the hid-core
subsystem will tag the hid device as a sensor one, meaning that udev
will modprobe the driver if it's not already loaded.
So if you still have to manually modprobe your driver (or maybe you
are talking about the mfd driver), there is a bug in the detection of
sensors devices. And this has to be fixed :)

Cheers,
Benjamin
