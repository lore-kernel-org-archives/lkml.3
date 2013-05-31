Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3EaDrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 23:47:33 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52292 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3EaDr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 23:47:28 -0400
MIME-Version: 1.0
In-Reply-To: <b1c6c2652b302431a4d4cff46ac872db8e520b6a.1368485053.git.luto@amacapital.net>
References: <cover.1368485053.git.luto@amacapital.net>
	<b1c6c2652b302431a4d4cff46ac872db8e520b6a.1368485053.git.luto@amacapital.net>
Date: Fri, 31 May 2013 13:47:26 +1000
Message-ID: <CAPM=9tx+pdFmXnLzZKpa1VcvH_6siydZckhLVSWOM_aJAj0WUg@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] drm: Update drm_addmap and drm_mmap to use PAT WC
 instead of MTRRs
From: Dave Airlie <airlied@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 9:58 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Previously, DRM_FRAME_BUFFER mappings, as well as DRM_REGISTERS
> mappings with DRM_WRITE_COMBINING set, resulted in an unconditional
> MTRR being added but the actual mappings being created as UC-.
>
> Now these mappings have the MTRR added only if needed, but they will
> be mapped with pgprot_writecombine.
>
> The non-WC DRM_REGISTERS case now uses pgprot_noncached instead of
> hardcoding the bit twiddling.
>
> The DRM_AGP case is unchanged for now.

Just FYI this breaks on powerpc build, I've fixed it up and pushed the
fixed version to
drm-next-staging, I'll push that to drm-next in a couple of days, once
kbuild robot hits it.

Dave.
