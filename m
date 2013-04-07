Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148Ab3DGRZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 13:25:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36454 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934130Ab3DGRZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 13:25:54 -0400
Date: Sun, 7 Apr 2013 19:25:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, x86@kernel.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        khlebnikov@openvz.org, bhelgaas@google.com
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
Message-ID: <20130407172545.GF31299@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@linux.intel.com>, Dave Hansen <dave@sr71.net>,
	linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
	x86@kernel.org, akpm@linux-foundation.org,
	suresh.b.siddha@intel.com, khlebnikov@openvz.org,
	bhelgaas@google.com
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
 <20130407133346.GD31299@pd.tnic>
 <51619FFF.30705@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51619FFF.30705@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 09:34:07AM -0700, H. Peter Anvin wrote:
> We shouldn't, no. /dev/mem really needs to be fixed along a bunch of
> axes. Yes, it is privileged and extra creepy, but it should either
> work or it should fail cleanly.

Can't we filter out accesses through /dev/mem and not BUG_ON in
__phys_addr() if they come through /dev/mem? Simply fail cleanly. No
idea whether we'll break something still reading /dev/mem though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
