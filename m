Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaIZLDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:03:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbaIZLDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:03:41 -0400
Date: Fri, 26 Sep 2014 13:03:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Ping Cheng <pinglinux@gmail.com>, killertofu@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] HID: wacom: introduce generic HID handling
In-Reply-To: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1409261302520.22196@pobox.suse.cz>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Benjamin Tissoires wrote:

> Hi guys,
> 
> So, this patch series aims at supporting natively any future HID compliant wacom
> tablet. Those found on the various laptops (ISDv4/5) already are HID compliant
> and they should work in the future without any modification of the kernel.
> 
> Few things to note here:
> - I used the PID 0x00E6 found on the Lenovo X230 for the tests
> - I did not removed its entry in the list because there is a slightly different
>   behavior while using this patch set: when more than two fingers are on the
>   screen, the tablet stops sending finger events, while with the wacom
>   proprietary bits, it continues to send them. Besides that, the events emitted
>   before and after the patch series are the same (at least on the E6)
> - I can not rely on hid-input directly because wacom wants to be in control of
>   the input devices it creates. This might be solved in the future, but for now
>   it is just easier to rewrite the few mapping/events handling than trying to
>   fit in the hid-input model.
> - there will still be more specific use cases to handle later (see the joke of
>   the MS surface 3 pen[1] for instance), but this should give a roughly working
>   pen/touch support for those future devices.
> 
> Jason, I would be very glad if you could conduct a few tests for this on the
> ISDv4/5 sensors you have.

I am waiting with this one for testing results from Jason, but if you guys 
want this to go in the next merge window, I'd like to ask you not to 
postpone the testing too much.

Thanks.

> 
> Cheers,
> Benjamin
> 
> [1] http://who-t.blogspot.com/2014/09/stylus-behaviour-on-microsoft-surface-3.html
> 
> Benjamin Tissoires (5):
>   HID: wacom: rename failN with some meaningful information
>   HID: wacom: split out input allocation and registration
>   HID: wacom: move allocation of inputs earlier
>   HID: wacom: implement generic HID handling for pen generic devices
>   HID: wacom: implement the finger part of the HID generic handling
> 
>  drivers/hid/hid-core.c  |   3 +
>  drivers/hid/wacom.h     |   6 +
>  drivers/hid/wacom_sys.c | 184 +++++++++++++++++++++--------
>  drivers/hid/wacom_wac.c | 299 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/wacom_wac.h |  17 +++
>  include/linux/hid.h     |   2 +
>  6 files changed, 462 insertions(+), 49 deletions(-)
> 
> -- 
> 2.1.0
> 

-- 
Jiri Kosina
SUSE Labs
