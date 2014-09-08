Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaIHPRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:17:21 -0400
Received: from plane.gmane.org ([80.91.229.3]:52230 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbaIHPRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:17:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Subject: [BISECTED] (?) since 3.16: USB video cam of an HP Pavilion dv7 laptop
 not working
Date: Mon, 08 Sep 2014 17:17:05 +0200
Message-ID: <540DC871.7040901@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
X-Gmane-NNTP-Posting-Host: p5b37afdd.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 3.16 the builtin USB video cam of an HP Pavilion dv7 laptop shows only a
black screen with the application guvcview although the video LED is turned on.
There is no hint in dmesg. Also the output of guvcview shows no conspicuousness.

With kernel version 3.15.9 the camera works.

I tried to bisect between good v3.15 and bad v3.16, which identified

commit 9262c19d14c433a6a1ba25c3ff897cb89e412309
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 20 18:08:12 2014 -0700

    usb: disable port power control if not supported in wHubCharacteristics

    A hub indicates whether it supports per-port power control via the
    wHubCharacteristics field in its descriptor.  If it is not supported
    a hub will still emulate ClearPortPower(PORT_POWER) requests by
    stopping the link state machine.  However, since this does not save
    power do not bother suspending.

    This also consolidates support checks into a
    hub_is_port_power_switchable() helper.

    Acked-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In the bad bisection steps the video device even was not found. Therefore, I'm
not sure if I identified the right culprit.

Thanks for any help,
Jörg-Volker.

