Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431Ab3DDF1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:27:30 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:63524 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab3DDF12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:27:28 -0400
Message-ID: <515D0F5E.5010805@prisktech.co.nz>
Date: Thu, 04 Apr 2013 18:27:58 +1300
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: tomi.valkeinen@ti.com
CC: Tony Prisk <linux@prisktech.co.nz>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com
Subject: Re: [PATCHv3 0/6] fb: vt8500: patches for 3.10
References: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364926838-6721-1-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/13 07:20, Tony Prisk wrote:
> V3 Changes:
> Tidied up patch 1 as requested by Jean-Christophe - Makes the patch much
> simpler.
>
> V2 Changes:
> Split the SoC and board portions of the binding into their respective files.
> Removed the forced non-interlaced code from wm8505fb.c and vt8500lcdfb.c
>
> Julia Lawall (1):
>    drivers/video/wm8505fb.c: use devm_ functions
>
> Tony Prisk (5):
>    video: vt8500: Make wmt_ge_rops optional
>    video: vt8500: Remove unused platform_data/video-vt8500lcdfb.h
>    video: vt8500: Correct descriptions in video/Kconfig
>    video: vt8500: Adjust contrast in wm8505 framebuffer driver.
>    video: fb: vt8500: Convert framebuffer drivers to standardized
>      binding
>
>   .../devicetree/bindings/video/via,vt8500-fb.txt    |   48 ++-----
>   .../devicetree/bindings/video/wm,wm8505-fb.txt     |   32 +++--
>   arch/arm/boot/dts/vt8500-bv07.dts                  |   34 ++---
>   arch/arm/boot/dts/vt8500.dtsi                      |    4 +-
>   arch/arm/boot/dts/wm8505-ref.dts                   |   34 ++---
>   arch/arm/boot/dts/wm8505.dtsi                      |    4 +-
>   arch/arm/boot/dts/wm8650-mid.dts                   |   36 +++--
>   arch/arm/boot/dts/wm8650.dtsi                      |    4 +-
>   arch/arm/boot/dts/wm8850-w70v2.dts                 |   40 +++---
>   arch/arm/boot/dts/wm8850.dtsi                      |    4 +-
>   drivers/video/Kconfig                              |   37 +++--
>   drivers/video/vt8500lcdfb.c                        |   55 +++-----
>   drivers/video/wm8505fb.c                           |  144 ++++++--------------
>   drivers/video/wmt_ge_rops.h                        |   23 ++++
>   include/linux/platform_data/video-vt8500lcdfb.h    |   31 -----
>   15 files changed, 211 insertions(+), 319 deletions(-)
>   delete mode 100644 include/linux/platform_data/video-vt8500lcdfb.h
>
Tomi,

If no one has any further comments, are you still prepared to take this 
series?
If so, I will send a pull-request.

With regards to the earlier concern about your current patch series, I 
think its easiest if you do take this series then you could do a fixup 
patch if this one is merged first. From what I remember of your series, 
it is basically a rename of of_get_display_timings() to 
of_get_display_timing() and some new code which I don't use. Seems a 
rather trivial patch for a fixup later.

Let me know what you want to do.

Regards
Tony P
