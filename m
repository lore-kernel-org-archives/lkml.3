Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3BTS4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:56:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50550 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933Ab3BTS4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:56:37 -0500
Date: Wed, 20 Feb 2013 19:56:33 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH v2] drm/nouveau: always select ACPI_VIDEO if ACPI is
 enabled.
Message-ID: <20130220185633.GF16775@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
References: <20130204152344.GG13909@pd.tnic>
 <510FD6A2.80101@canonical.com>
 <20130205145232.GI4827@pd.tnic>
 <5111277B.5020607@canonical.com>
 <20130205162206.GJ4827@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130205162206.GJ4827@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:22:06PM +0100, Borislav Petkov wrote:
> On Tue, Feb 05, 2013 at 04:38:35PM +0100, Maarten Lankhorst wrote:
> > Argh, next attempt, based on i915's Kconfig.
> > 
> > It seems that not only I have to select ACPI_VIDEO, I also have to select all the dependencies.
> > Is this a Kconfig bug or working as intended? i915 seems to have a workaround, so I copied it from
> > there. Except it's currently missing select THERMAL, so I guess it didn't get updated when that got
> > added.
> > 
> > ---->8
> > Having nouveau builtin would still allow ACPI_VIDEO to be used as external module
> > if some of the deps for acpi_video have not been met, which would result in a linking
> > failure. Solve this by selecting all dependencies as well.
> > 
> > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> 
> Yep, this takes care of all deps,
> 
> Tested-by: Borislav Petkov <bp@suse.de>

Just to check whether anyone has picked this already - it is triggering
on 3.8 too so it most probably needs a stable tag too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
