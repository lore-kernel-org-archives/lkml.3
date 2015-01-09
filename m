Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbbAIMkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:40:32 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55834 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbbAIMk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAMFK4TMNuQEao5n3XPjn4ZSkX0eTtfkWO+h=bPbyHthyJYebPw@mail.gmail.com>
References: <1419259269-23820-1-git-send-email-dforsi@gmail.com>
	<CAMFK4TMNuQEao5n3XPjn4ZSkX0eTtfkWO+h=bPbyHthyJYebPw@mail.gmail.com>
Date: Fri, 9 Jan 2015 13:40:28 +0100
Message-ID: <CAMFK4TPQVMy0K_SLcF9q=2f1buaisg6C6ozFoAp3L7saEqidng@mail.gmail.com>
Subject: Fwd: [RFC PATCH 0/2] USB: input: yealink.c: update key mappings
From: Henk <henk.vergonet@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Danielle,

Thanks for the '#' fix!

> DRIVER_VERSION should be updated?
Yes seems logical, considering that the API has changed slightly by
using NUMERIC scan commands. I would suggest:

#define DRIVER_VERSION "yld-20141222"

So users something is new and can track changes to your patches more easily.

> are both patches suitable for stable?

I would have no objection to that :)

Regards,
Henk Vergonet

On Mon, Dec 22, 2014 at 3:41 PM, Daniele Forsi <dforsi@gmail.com> wrote:
>
> Hello,
>
> I have an Yealink USB phone which is handled by the yealink.c driver but the
> '#' key returns an unexpected value and keys labeled "RING" and "MUTE" do not
> return any value to userspace.
>
> In the first patch of this series I replace the combination KEY_LEFTSHIFT and
> KEY_3 with KEY_NUMERIC_POUND and I also replace other keys for internal consistency
> and with the cm109.c driver, which according to the comment in the code is derived
> from this one, is this the right approach?
>
> In the second patch I add two additional keys which could be handled by userspace:
>  "RING" whose purpose according to the user manual is to cycle all available ringtones
>  "MUTE" whose purpose is to mute the USB microphone
> which KEY_* values should be used for them?
>
> I have two more questions:
> DRIVER_VERSION should be updated?
> are both patches suitable for stable?
>
> Daniele Forsi (2):
>   USB: input: yealink.c: use KEY_NUMERIC_* for numeric keys, star and
>     pound
>   USB: input: yealink.c: add mapping for "RING" and "MUTE" keys
>
>  drivers/input/misc/yealink.c | 43 +++++++++++++++++++------------------------
>  1 file changed, 19 insertions(+), 24 deletions(-)
>
> --
> 2.1.3
>
