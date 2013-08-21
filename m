Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3HUVRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:17:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:33554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab3HUVRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:17:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="366448998"
Message-ID: <52153015.6060409@linux.intel.com>
Date: Wed, 21 Aug 2013 14:24:37 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] HID: Win 8 multitouch panels detection in core
References: <1377099620-23947-1-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1377099620-23947-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 08:40 AM, Benjamin Tissoires wrote:
> Hi guys,
>
> this is the v2 of the rework of the pre-scanning of the hid report descriptors.
> This allows us to be able to detect Win 8 multitouch panels.
> I tried to take into account all of the previous reviews, and I think the patch
> series is in a better shape now.
>
> Alexander, Srinivas, could you please review/test patches 1/3 and 2/3 as they
> will both impact hid_sensor_hub detection now. From the report descriptors
> Alexander sent, I would say that it will work now, but it's always better to
> have different testers :)
Tested sensor hub. It works.
>
> Cheers,
> Benjamin
>
> Changes in v2:
> - moved "flags" processing in patch 2/3
> - do not introduce parser->flags, but use hid->group as a temporary flag placeholder
> - hid_scan_report() is less verbose when errors are found in the descriptor
> - hid_scan_report() is tolerant to parsing errors
> - fixed usage_page handling in hid_scan_collection(), which fixes sensors detection
> - amended commit messages
> - #define and #undef HID_FLAG_* in hid-core.c instead of hid.h
>
> Benjamin Tissoires (3):
>    HID: Use hid_parser for pre-scanning the report descriptors
>    HID: detect Win 8 multitouch devices in core
>    HID: do not init input reports for Win 8 multitouch devices
>
>   drivers/hid/hid-core.c        | 143 ++++++++++++++++++++++++++++++------------
>   drivers/hid/hid-multitouch.c  |  36 +++++++----
>   drivers/hid/usbhid/hid-core.c |  11 +++-
>   include/linux/hid.h           |   2 +
>   4 files changed, 137 insertions(+), 55 deletions(-)
>

