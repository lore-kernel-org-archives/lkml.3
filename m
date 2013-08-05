Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3HENWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:22:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54001 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3HENWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:22:18 -0400
Date: Mon, 5 Aug 2013 15:22:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never
 set
In-Reply-To: <CAN+gG=FV=OjnktkET-_KM_iTPStsWCKdj8fpyktnJczusFz0=w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1308051516181.17512@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com> <1374153691-25100-2-git-send-email-nlopezcasad@logitech.com> <CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com> <alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>
 <CAN+gG=FV=OjnktkET-_KM_iTPStsWCKdj8fpyktnJczusFz0=w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Aug 2013, Benjamin Tissoires wrote:

> > Could you please elaborate? (and put an elaborate description to revert
> > commit log perhaps?)
> 
> Sure, so here is the revert commit log:
> 
> --
> 
> Commit "HID: hid-logitech-dj, querying_devices was never set" activate
> a flag which guarantees that we do not ask the receiver for too many
> enumeration. When the flag is set, each following enumeration call is
> discarded (the usb request is not forwarded to the receiver). The flag
> is then released when the driver receive a pairing information event,
> which normally follows the enumeration request.
> However, the USB3 bug makes the driver think the enumeration request
> has been forwarded to the receiver. However, it is actually not the
> case because the USB stack returns -EPIPE. So, when a new unknown
> device appears, the workaround consisting in asking for a new
> enumeration is not working anymore: this new enumeration is discarded
> because of the flag, which is never reset.
> 
> A solution could be to trigger a timeout before releasing it, but for
> now, let's just revert the patch.
> 
> --

Thanks Benjamin.

I'd like to have a bit more clarification about the USB3 bug, as this 
whole issue is not completely clear to me.

To be more specific -- when exactly do we receive -EPIPE, why do we 
receive it and why do we not handle it properly?

Thanks again,

-- 
Jiri Kosina
SUSE Labs
