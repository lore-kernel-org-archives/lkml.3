Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbbA2BHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:07:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbA2BHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:07:16 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] New Lenovos 2015 touchpads: party time!
Date: Wed, 28 Jan 2015 15:10:03 -0500
Message-Id: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Lenovo released their new models, and believe it or not, some kernel
work is required to support them!

We learned the lesson and we will try to maximize the effort in user space
through udev rules instead of polluting the kernel with exceptions.

Patches 1 & 2 are general fixes for synaptics that have been unnoticed
until this new models. They are marked as stable.

Patch 3 is a generic way to fix the PnpId list that was hardcoded in the
kernel. This one is also marked as stable so that distributions will not
have the top software buttons on devices that do not require it.

Patch 4 is a nice to have. It is not mandatory, so not CC-ed to stable,
it just reduced the PnpId list.

The good thing is that the reported min/max are correct, so the problems
with the first generation of the t440 touchpad have been fixed now (and
synaptics assured us that they will keep checking the quality of the PS/2
handling of their touchpads).

One last thing, I still did not manage to talk to the device over SMBus,
so we are still stuck with the PS/2 protocol and its limitations for this
series.

Cheers,
Benjamin

Benjamin Tissoires (4):
  Input - synaptics: fix middle button on Lenovo 2015 products
  Input - synaptics: do not release extra buttons once they are pressed
  Input - synaptics: remove TOPBUTTONPAD property for Lenovos 2015
  Input - synaptics: Remove X1 Carbon 3rd gen from the topbuttonpad list

 drivers/input/mouse/synaptics.c | 20 ++++++++++++++------
 drivers/input/mouse/synaptics.h |  3 +++
 2 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.1.0

