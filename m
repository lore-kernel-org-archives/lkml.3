Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaESO7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:59:08 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:53982 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaESO7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <1398263514-7281-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1398263514-7281-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Mon, 19 May 2014 10:59:04 -0400
Message-ID: <CAN+gG=HtdpTkZ6eo_WCBuwy_XkEjycb12jtj4eBo=P1goJUeeg@mail.gmail.com>
Subject: Re: [PATCH] HID: rmi: do not handle touchscreens through hid-rmi
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Duggan <aduggan@synaptics.com>,
        Christopher Heiny <cheiny@synaptics.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:31 AM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Currently, hid-rmi drives every Synaptics product, but the touchscreens
> on the Windows tablets should be handled through hid-multitouch.
>
> Instead of providing a long list of PIDs, rely on the scan_report
> capability to detect which should go to hid-multitouch, and which
> should not go to hid-rmi.
>
> We introduce a generic HID_GROUP_HAVE_SPECIAL_DRIVER which can be reused
> amoung other drivers if they want to have a catch rule but still
> have multitouch devices handled through hid-multitouch.
>
> related bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=74241
> https://bugzilla.redhat.com/show_bug.cgi?id=1089583
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>
> Hi Jiri,
>
> well, this is the patch we are going to carry in Fedora as we are already
> carrying hid-rmi.
> Still, I am not 100% happy with it, especially the HID_GROUP_HAVE_SPECIAL_DRIVER
> thing.
>
> I would also say we should re-think the way the scanning is called in
> hid_add_device because I am starting using more and more the scanning capability
> to decide if the device should be handled by generic, a special driver or simply
> ignored.
>
> Anyway, this could be decided later. If you prefer me to use a hid-rmi specific
> group like HID_GROUP_RMI instead of HID_GROUP_HAVE_SPECIAL_DRIVER, I can also
> update the patch.
>

Hi Jiri,

looks like this one did not attracted your eye yet. Can you ack / nack it?
Without it, hid-rmi will break all the multitouch screens from
Synaptics, which will be a little bit worrying :)

Cheers,
Benjamin
