Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaG1Rnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:43:45 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49506 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaG1Rnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:43:39 -0400
Date: Mon, 28 Jul 2014 10:43:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Message-ID: <20140728174334.GD8982@core.coreip.homeip.net>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Mon, Jul 28, 2014 at 11:53:23AM -0500, Dan Murphy wrote:
> Add the TI drv260x haptics/vibrator driver.
> This device uses the input force feedback
> to produce a wave form to driver an
> ERM or LRA actuator device.
> 
> The initial driver supports the devices
> real time playback mode.  But the device
> has additional wave patterns in ROM.

As it presented the device appears to be a memoryless device, however
you present it to the rest of the system as if it can support playback
of multiple effects simultaneously, which is incorrect.

My guess that you need to engage the memoryless input library to schedule
handling multiple effects for your device, including ramping up, ramping
down, stopping playback when effects runs out, etc.

Thanks.
 
-- 
Dmitry

P.S. If you are using devm_ there is devm_input_allocate_dveice().
