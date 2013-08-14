Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab3HNMce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:32:34 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37334 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188Ab3HNMcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130814121606.GB23840@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1375741218-10225-2-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130814121606.GB23840@n2100.arm.linux.org.uk>
Date: Wed, 14 Aug 2013 08:32:32 -0400
Message-ID: <CAF6AEGsLLWjNRv4PJwkyWaQ0nTLUfW8ShtcMESoXBVjLSiF7Rw@mail.gmail.com>
Subject: Re: [PATCH 1/8] drm/i2c: tda998x: fix EDID reading on TDA19988 devices
From: Rob Clark <robdclark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 8:16 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Aug 06, 2013 at 12:20:11AM +0200, Sebastian Hesselbarth wrote:
>> From: Russell King <rmk+kernel@arm.linux.org.uk>
>>
>> TDA19988 devices need their RAM enabled in order to read EDID
>> information.  Add support for this.
>>
>> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
> There was some debate about whether this is needed or not.  It seems that
> if I don't run the NXP driver, it isn't needed, but if I have run the
> NXP driver, then yes it is.  As it seems to do no harm, I think it's fine
> to be submitted.

just fwiw, I had noticed before that (at least on the
beaglebone-black), nxp doesn't necessarily get reset when doing a warm
reboot.  So booting a kernel w/ NXP driver, and then rebooting w/
upstream kernel and tda998x should probably hit this same scenario.
Better to not assume too much about the state of the tda when the
driver is loaded, so I think this patch is a good idea.

Signed-off-by: Rob Clark <robdclark@gmail.com>

BR,
-R
