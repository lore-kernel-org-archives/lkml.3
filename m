Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaKKMrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:47:11 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37451 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaKKMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:47:09 -0500
MIME-Version: 1.0
In-Reply-To: <1415041531-15520-3-git-send-email-soren.brinkmann@xilinx.com>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	<1415041531-15520-3-git-send-email-soren.brinkmann@xilinx.com>
Date: Tue, 11 Nov 2014 13:47:08 +0100
Message-ID: <CACRpkdbOLMT1vfFg=CAU_VHdjxPWn_Ybso=+8Asp=mXhmNBRSA@mail.gmail.com>
Subject: Re: [PATCH 2/7] pinctrl: pinconf-generic: Infer map type from DT property
From: Linus Walleij <linus.walleij@linaro.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> With the new 'groups' property, the DT parser can infer the map type
> from the fact whether 'pins' or 'groups' is used to specify the pin
> group to work on.
> To maintain backwards compatibitliy with current usage of the DT
> binding, this is only done when an invalid map type is passed to the
> parsing function.

So that is this:

> +               if (type == PIN_MAP_TYPE_INVALID)
> +                       type = PIN_MAP_TYPE_CONFIGS_GROUP;
> +               dt_pin_specifier = "groups";

This is just kludgy. There are only two kernel-internal users of this function,
refactor the function signature and change the other callers over instead,
patch the drivers.

Take this opportunity to add some kerneldoc above the
pinconf_generic_dt_subnode_to_map() and give the function a
reasonable signature.

BTW: this is just for config settings for groups right? Not for muxing
I hope?

Yours,
Linus Walleij
