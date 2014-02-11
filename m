Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaBKPjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:39:45 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50682 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaBKPjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:39:44 -0500
Message-ID: <1392133181.3755.14.camel@x220>
Subject: drm/msm:  CONFIG_MSM_OCMEM?
From: Paul Bolle <pebolle@tiscali.nl>
To: Rob Clark <robdclark@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 16:39:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 15:39:42.0320 (UTC) FILETIME=[7B5DC700:01CF273F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

Commit 55459968176f ("drm/msm: add a330/apq8x74") added preprocessor
checks for CONFIG_MSM_OCMEM. But I couldn't find a Kconfig symbol
MSM_OCMEM (nor a preprocessor define for a macro of that name). Why were
those preprocessor checks added?

Please note that lines 197-201 currently read:
    /* Set the OCMEM base address for A330, etc */
    if (a3xx_gpu->ocmem_hdl) {
            gpu_write(gpu, REG_A3XX_RB_GMEM_BASE_ADDR,
                    (unsigned int)(a3xx_gpu->ocmem_base >> 14));
    }

ocmem_hdl and ocmem_base are used uninitialized here, aren't they? So it
seems these lines should be wrapped with a preprocessor check for
CONFIG_MSM_OCMEM too.


Paul Bolle

