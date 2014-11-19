Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaKSSGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:06:46 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:58899 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaKSSGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:06:44 -0500
Date: Wed, 19 Nov 2014 10:06:39 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@zonque.org>
Cc: "jeffrey.lin" <yajohn@gmail.com>, rydberg@euromail.se, bleung@chromium.org,
        dh.herrmann@gmail.com, charliemooney@chromium.org, floe@butterbrot.org,
        jeffrey.lin@rad-ic.com, roger.yang@rad-ic.com, KP.li@rad-ic.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        "jeffrey.lin" <jeffrey.lin@gmail.com>
Subject: Re: [PATCH] driver: input: touchscreen:  add Raydium i2c touchscreen
 driver
Message-ID: <20141119180639.GD37989@dtor-ws>
References: <1416411048-23526-1-git-send-email-jeffrey.lin@rad-ic.com>
 <546CC900.8000506@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546CC900.8000506@zonque.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:44:48PM +0100, Daniel Mack wrote:
> On 11/19/2014 04:30 PM, jeffrey.lin wrote:
> > From: "jeffrey.lin" <jeffrey.lin@gmail.com>
> > 
> > this patch is porting Raydium I2C touch driver. Developer can enable
> > raydium touch driver by modifying define "CONFIG_TOUCHSCREEN_RM_TS".
> > 
> > BUG: None
> > TEST: built and test with peppy
> > 
> > Signed-off-by: jeffrey.lin@rad-ic.com
> > Change-Id: I05d54e5ef29249d2a6eae97222c90bed11e839f9
> > ---
> 
> Just some general remarks that IMO need to be addressed before a more
> thorough review can happen:
> 
> 
> * Please remove all dead code, such as code in comments and in #if 0
>   blocks.
> 
> * Use the regmap framework to abstract the hardware access on the I2C
>   layer (see drivers/input/keyboard/cap1106.c and many other drivers
>   as an example, and check include/linux/regmap.h). That makes the code
>   a lot shorter and more comprehensible to read.
> 
> * By using request_threaded_irq(), you don't have to manually control
>   your worker and can simplify your code quite a bit.
> 
> * See if you can claim all the resources the driver needs by using
>   devm_* variants.
> 
> * Don't use uppercase names for filenames, structs, functions and IDs
> 
> * Why do you need a miscdevice for this? Isn't the input event layer
>   enough?
> 
> * Also, run scripts/checkpatch.pl on the new patch, which will help
>   you find some more typical pitfalls.

Also please convert driver to MT-B (slotted) protocol (you are currently
using MT-Ai version).

And please remove join_bytes(). It is called get_unaligned_le16().

Most of the things that need fixing have already been listed in response
to your original submission, please do address them before posting the
driver again.

Thanks.

-- 
Dmitry
