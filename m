Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3CFTmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:42:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34365 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab3CFTmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:42:14 -0500
Date: Wed, 6 Mar 2013 20:42:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas Stach <dev@lynxeye.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: nouveau lockdep splat
Message-ID: <20130306194209.GE30673@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Stephen Warren <swarren@nvidia.com>, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lucas Stach <dev@lynxeye.de>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, nouveau@lists.freedesktop.org,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>
References: <20130304211608.GD22274@pd.tnic>
 <1362501052.1933.2.camel@antimon>
 <20130306000429.GA30189@pd.tnic>
 <20130306191418.GA3400@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130306191418.GA3400@joi.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:14:18PM +0100, Marcin Slusarz wrote:
> On Wed, Mar 06, 2013 at 01:04:29AM +0100, Borislav Petkov wrote:
> > On Tue, Mar 05, 2013 at 05:30:52PM +0100, Lucas Stach wrote:
> > > Dropping Tegra ML, it's not the place where Nouveau mails should go.
> > 
> > $ ./scripts/get_maintainer.pl -f drivers/gpu/drm/nouveau/nv50_display.c
> > ...
> > linux-tegra@vger.kernel.org (open list:TEGRA SUPPORT)
> > 
> > Maybe get_maintainer.pl patterns need correction...
> 
> That's new feature (introduced in commit eb90d0855b75f8 "get_maintainer: allow
> keywords to match filenames") of get_maintainer.pl which now can look at file
> contents...
> 
> TEGRA SUPPORT
> M:	Stephen Warren <swarren@wwwdotorg.org>
> L:	linux-tegra@vger.kernel.org
> Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
> S:	Supported
> K:	(?i)[^a-z]tegra
> 
> Note the last line and this:
> 
> $ grep tegra drivers/gpu/drm/nouveau/nv50_display.c
>         u32 rekey = 56; /* binary driver, and tegra constant */
>         max_ac_packet -= 18; /* constant from tegra */
> 
> Fun.

Yeah, and a lot of it, thanks for digging this out. So obviously this
regex is a bit... unfortunate. Although the idea of grepping the files
for unique patterns is not bad, I have to admit.

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
