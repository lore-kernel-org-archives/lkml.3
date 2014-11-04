Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaKDJIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:08:05 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60195 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaKDJH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:07:59 -0500
Date: Tue, 4 Nov 2014 09:07:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: use of_find_backlight_by_node stub when
 backlight class disabled
Message-ID: <20141104090754.GG17577@x1>
References: <50522512.UJWUZtqLop@diego>
 <20141103171731.GH12011@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141103171731.GH12011@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2014, Lee Jones wrote:

> On Wed, 29 Oct 2014, Heiko Stübner wrote:
> 
> > Drivers may want to search for an optional backlight even when the backlight
> > class is disabled. In this case the linker would miss the function referenced
> > in the backlight header.
> > 
> > Therefore use the stub function also when the backlight class is disabled.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> >  include/linux/backlight.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied to Backlight -next with Jingoo's Ack.

I've removed this patch, as it causes unexpected:

  Redefinition of of_find_backlight_by_node()

... error.

Bear in mind that defined(CONFIG_BACKLIGHT_CLASS_DEVICE) is false if
it's built in as a module.  Change to nested #ifdefs instead.

> > diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> > index adb14a8..d9cb644 100644
> > --- a/include/linux/backlight.h
> > +++ b/include/linux/backlight.h
> > @@ -157,7 +157,7 @@ struct generic_bl_info {
> >  	void (*kick_battery)(void);
> >  };
> >  
> > -#ifdef CONFIG_OF
> > +#if defined(CONFIG_OF) && defined(CONFIG_BACKLIGHT_CLASS_DEVICE)
> >  struct backlight_device *of_find_backlight_by_node(struct device_node *node);
> >  #else
> >  static inline struct backlight_device *
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
