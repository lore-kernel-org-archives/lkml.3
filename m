Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaKJXho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:37:44 -0500
Received: from gloria.sntech.de ([95.129.55.99]:33673 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaKJXhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:37:43 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Bryan Wu'" <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: use of_find_backlight_by_node stub when backlight class disabled
Date: Tue, 11 Nov 2014 00:41:10 +0100
Message-ID: <1767565.D903P0xsEy@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141104171532.GS17577@x1>
References: <50522512.UJWUZtqLop@diego> <28305505.Hd0ru0QyPE@diego> <20141104171532.GS17577@x1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Dienstag, 4. November 2014, 17:15:32 schrieb Lee Jones:
> Actually there is a better way still:
> 
> #ifdef CONFIG_OF && IS_ENABLED(CONFIG_BACKLIGHT_CLASS_DEVICE)
> struct backlight_device *of_find_backlight_by_node(struct device_node
> *node); #else
> static inline struct backlight_device *
> of_find_backlight_by_node(struct device_node *node)
> {
>       return NULL;
> }
> #endif

After further looking at the problem, I'm actually not even sure, if my 
approach is the best one at all.

The problem I was trying to fix was panel-simple (drivers/gpu/drm/panel/panel-
simple.c) checking for an optional backlight, while not depending on the 
backlight-class itself.

As both components do not have a relationship, there exist the possibility of 
panel-simply being build into the kernel while the backlight_class is build as 
module. So while the IS_ENABLED check would define the prototype, panel-generic 
would still miss the function when linking.

Should panel-generic simply depend in the backlight_class instead?


Thanks
Heiko
