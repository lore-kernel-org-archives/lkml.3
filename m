Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaA3Qrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:47:42 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:38353 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaA3Qrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:47:40 -0500
MIME-Version: 1.0
Date: Thu, 30 Jan 2014 11:47:39 -0500
X-Google-Sender-Auth: Vi9HO6SoadhC73jxa0cGqpFfpKw
Message-ID: <CA+5PVA6CNam9F_n=Sz9o=4-RHVCVczeJ1G1_EzcUTj92nzALFQ@mail.gmail.com>
Subject: exynos_hdmi.c fails to build with v3.13-10094-g9b0cd30
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-samsung-soc@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

After the DRM merge, the exynos_hdmi.c file fails to build with our
ARM config.  The error is:

drivers/gpu/drm/exynos/exynos_hdmi.c:382:8: error: 'hdmi_infoframe'
defined as wrong kind of tag
 struct hdmi_infoframe {
        ^
make[4]: *** [drivers/gpu/drm/exynos/exynos_hdmi.o] Error 1
make[3]: *** [drivers/gpu/drm/exynos] Error 2
make[2]: *** [drivers/gpu/drm] Error 2

which to me was a somewhat confusing error message.  After digging
further, I believe it means that there is a conflict with the
definition in exynos_hdmi.c and the one found in include/linux/hdmi.h
for what hdmi_infoframe is supposed to be.

exynos_hdmi.c:

struct hdmi_infoframe {
        enum HDMI_PACKET_TYPE type;
        u8 ver;
        u8 len;
};


include/linux/hdmi.h:

union hdmi_infoframe {
        struct hdmi_any_infoframe any;
        struct hdmi_avi_infoframe avi;
        struct hdmi_spd_infoframe spd;
        union hdmi_vendor_any_infoframe vendor;
        struct hdmi_audio_infoframe audio;
};


Could someone take a look at this?  I have no idea how this wasn't
caught before being merged.

josh
