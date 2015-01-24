Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbbAXPPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:15:08 -0500
Received: from gloria.sntech.de ([95.129.55.99]:35871 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbbAXPPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:15:04 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: dri-devel@lists.freedesktop.org
Cc: Mark Yao <mark.yao@rock-chips.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v2 0/2] drm/rockchip: Optimization vop dpms control
Date: Sat, 24 Jan 2015 16:14:54 +0100
Message-ID: <4077998.GJIlik9CKQ@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
References: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. Januar 2015, 18:29:55 schrieb Mark Yao:
> drm dpms have many power modes, ON,OFF,SUSPEND,STANDBY, etc.
> but vop only have enable/disable mode, maybe case such bug:
>  --> DRM_DPMS_ON: power on vop
>  --> DRM_DPMS_SUSPEND: power off vop
>  --> DRM_DPMS_OFF: already power off at SUSPEND, crash
> so use a bool val is more suitable.
> 
> another problem at vop_crtc_dpms:
>   vop_enable()->drm_vblank_on, drm_vblank_on may call vop
> enable vblank. if it happen, vblank enable would failed,
> then cause irq status error. because is_enabled value is set
> after drm_vblank_on.

This series, on a rk3288-firefly board with a sda7123 vga connector
Tested-by: Heiko Stuebner <heiko@sntech.de>


Heiko
