Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaGKBVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 21:21:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55151 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGKBVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 21:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1403557039-1487-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 10 Jul 2014 18:21:13 -0700
Message-ID: <CANRwn3QsdGOnmuH3=PP=YaX1NpXrZwcB_1ccnTZ_bg2au=KJXg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Input - wacom: split out pad data from the stylus
 input device
From: Jason Gerecke <killertofu@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linuxwacom-devel <linuxwacom-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:57 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Hi,
>
> This patch series aims at simplifying the handling of Wacom devices from the user
> space point of view. As mentioned in the commit message from 1/5, the pad data
> are interleaved into the stylus input for some devices, and into the touch input
> for others.
>
> It doesn't makes real sense to interleave pad with stylus because pad data are
> not linked to the absolute position of a stylus (or its presence). It is a
> device by itself which should have its own input node.
>
> It will also help the handling of the old Wacom Graphire 4 which shares its
> BTN_LEFT and BTN_RIGHT in its pad and in the mouse.
>
> Again, it's not a problem right now because the user space is currently dealing
> with it, but for the Wayland libinput implementation, having something clear
> will really help.
>
> This patch series does not break current X11 behavior, the only change from the
> user will be that an input device will appear as "Wacom ... Pad pad".
>
> I tried to test/debug it as extensively as possible, but I do not guarantee any
> mistake :(
>
> Tested on:
> - Bamboo 16FG 4x5
> - Bamboo 2FG
> - BambooFun 4x5
> - Bamboo
> - Cintiq 12WX
> - Cintiq 21UX2
> - Cintiq 21UX
> - Cintiq 22HD
> - Cintiq 22HDT
> - Cintiq 24HD
> - DTU2231
> - Graphire3
> - Intuos3 9x12
> - Intuos4 WL
> - Intuos5 touch M
> - Intuos Pro S
>
> Note: this patch series might requesting to apply the patch for input->phys
> I just sent:
> https://patchwork.kernel.org/patch/4404391/
>
>
> Cheers,
> Benjamin
>
> Benjamin Tissoires (5):
>   Input - wacom: create a separate input device for pads
>   Input - wacom: split out the pad device for Intuos/Cintiq
>   Input - wacom: split out the pad device for Bamboos
>   Input - wacom: split out the pad device for DTUS
>   Input - wacom: split out the pad device for Graphire G4 and MO
>
>  drivers/input/tablet/wacom.h     |   2 +
>  drivers/input/tablet/wacom_sys.c |  63 +++++++-
>  drivers/input/tablet/wacom_wac.c | 328 ++++++++++++++++++++++++---------------
>  drivers/input/tablet/wacom_wac.h |   2 +
>  4 files changed, 259 insertions(+), 136 deletions(-)
>
> --
> 1.9.0
>

These look fine to me as well (aside from the one minor comment):

Reviewed-by: Jason Gerecke <killertofu@gmail.com>

Jason
---
Now instead of four in the eights place /
you’ve got three, ‘Cause you added one  /
(That is to say, eight) to the two,     /
But you can’t take seven from three,    /
So you look at the sixty-fours....
