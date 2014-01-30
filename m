Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaA3Mdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:33:35 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:63451 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbaA3Mde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:33:34 -0500
Message-ID: <1391085212.5170.9.camel@x41>
Subject: Re: [git pull] drm next tree
From: Paul Bolle <pebolle@tiscali.nl>
To: Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Thu, 30 Jan 2014 13:33:32 +0100
In-Reply-To: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Jan 2014 12:33:33.0061 (UTC) FILETIME=[7D031B50:01CF1DB7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie schreef op do 30-01-2014 om 02:49 [+0000]:
> Christian König (10):
>       [...]
>       drm/radeon: add GART debugfs access v3
>       [...]

That one generates a bit of (warning) noise when building on 32 bits
x86:

In file included from include/asm-generic/bug.h:13:0,
                 from [...]/linux/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/drm/drm_mm.h:39,
                 from include/drm/drm_vma_manager.h:26,
                 from include/drm/ttm/ttm_bo_api.h:35,
                 from drivers/gpu/drm/radeon/radeon_ttm.c:32:
drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_gtt_read':
include/linux/kernel.h:712:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
  (void) (&_min1 == &_min2);  \
                 ^
drivers/gpu/drm/radeon/radeon_ttm.c:938:22: note: in expansion of macro 'min'
   ssize_t cur_size = min(size, PAGE_SIZE - off);
                      ^

I suppose the last line should read
   ssize_t cur_size = min(size, (size_t) PAGE_SIZE - off);

to silence this. But I haven't tested yet.


Paul Bolle

