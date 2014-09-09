Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaIIMgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:36:33 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:38146 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753585AbaIIMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:36:31 -0400
Message-ID: <540EF44B.4070907@itdev.co.uk>
Date: Tue, 09 Sep 2014 13:36:27 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] Input: atmel_mxt_ts: Add of node type to the i2c table
References: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
In-Reply-To: <1410249158-18192-1-git-send-email-sjoerd.simons@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 08:52, Sjoerd Simons wrote:
> For i2c devices in OF the modalias exposed to userspace is i2c:<node
> type>, for the Maxtouch driver this is i2c:maxtouch.
> 
> Add maxtouch to the i2c id table such that userspace can correctly
> load the module for the device and drop the OF table as it's not
> needed for i2c devices.
> 
> Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>

I've tested this and it does work. In fact, it seems that you can use
	compatible = "i2c:atmel,maxtouch";

because the "atmel," is ignored in the matching.

Before I could ack this patch, we will need to update this dts file:
	arch/arm/boot/dts/s5pv210-goni.dts
and this documentation file:
	Documentation/devicetree/bindings/input/atmel,maxtouch.txt

thanks!
