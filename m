Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760505Ab3B0RtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:49:00 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34719 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3B0Rs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:48:59 -0500
MIME-Version: 1.0
In-Reply-To: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 27 Feb 2013 18:48:57 +0100
Message-ID: <CANq1E4Q8_J6W0oH7QH=vamtg0HRjimzk6N4M-9oSMRzyD=o-7A@mail.gmail.com>
Subject: Re: [RFC 0/2] HID: Introduce .idle() to remove last usb dependence
 from hid-multitouch
From: David Herrmann <dh.herrmann@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin

On Wed, Feb 27, 2013 at 4:38 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hi guys,
>
> Well, this series of two patches aims at removing the dependence between usb
> and hid-multitouch.
> I put a RFC and not a patch as I'm not satisfied with the result:
> - adding this callback for one use may not be accurate
> - the parameters may not be good either (HID_REQ_SET_IDLE is the only valid
>   value for now as noone seems to be using HID_REQ_GET_IDLE)
> - the return value is clearly not very interesting.
> - maybe we should just add HID_REQ_SET_IDLE to .request, but this will require
>   a few changes in the parameters.
>
> The main purpose of this RFC was to share it with David this new ll callback, so
> that we can have a global view of what is needed.

I actually never read the specs for SET/GET_IDLE. The Bluetooth HID
Profile deprecated these and I haven't seen a Bluetooth device that
relies on it. Any reasons why I should implement them?

Also, for things like UHID I think we can safely drop this request.
Considering that, I think the patches can be applied as they are, so:
  Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

The Bluetooth HID Profile actually implements some other SUSPEND
calls,  but these are supposed to be handled by the Bluetooth stack
independently of the HID driver. So if there is no other magic going
on with SET_IDLE, I'd just leave it for usbhid.

(does anyone know whether i2c-hid support these?)

Thanks
David
