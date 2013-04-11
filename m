Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965062Ab3DKOZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:25:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38963 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964874Ab3DKOZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:25:17 -0400
Message-ID: <1365690315.1929.8.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Date: Thu, 11 Apr 2013 07:25:15 -0700
In-Reply-To: <878v4pwa9l.fsf@nemi.mork.no>
References: <1365563834.27174.12.camel@joe-AO722>
	 <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
	 <20130411021415.GA16118@redhat.com> <878v4pwa9l.fsf@nemi.mork.no>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 13:56 +0200, Bjørn Mork wrote:
> I felt I had to share this little gem
> which showed up in drivers/gpu/drm/exynos/exynos_drm_vidi.c:
> 
> static int vidi_power_on(struct vidi_context *ctx, bool enable)
> {
>         struct exynos_drm_subdrv *subdrv = &ctx->subdrv;
>         struct device *dev = subdrv->dev;
> 
>         DRM_DEBUG_KMS("%s\n", __FILE__);
> 
>         if (enable != false && enable != true)
>                 return -EINVAL;
> ..
> That's taking failsafe to the next step :)

Cute.  It's a relatively new driver too so I'd guess
the "int -> bool conversion leftover" defense isn't
too likely.

