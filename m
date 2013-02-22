Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3BVK40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:56:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab3BVK4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:56:24 -0500
Date: Fri, 22 Feb 2013 11:56:21 +0100
From: Michal Marek <mmarek@suse.cz>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH v2 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
Message-ID: <20130222105621.GH12402@pobox.suse.cz>
References: <1360155419-12349-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360155419-12349-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 12:56:59PM +0000, James Hogan wrote:
> On architectures which have symbol prefixes, depmod emits lots of
> warnings like this:
> 
> WARNING: $module.ko needs unknown symbol $symbol
> 
> This is because depmod isn't being passed the -P <symbol_prefix>
> arguments to specify the symbol prefix to ignore. This option is
> included since the 3.13 release of module-init-tools.
> 
> Update scripts/depmod.sh to take extra arguments for the symbol prefix
> (required but may be empty), and update the main Makefile to always pass
> "$(CONFIG_SYMBOL_PREFIX)" to scripts/depmod.sh.
> 
> If the provided symbol prefix is non-empty, scripts/depmod.sh checks if
> depmod --version reports module-init-tools with a version number < 3.13
> otherwise it appends -P $SYMBOL_PREFIX to the depmod command line.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> ---
> changes since v1: clean up with assistance from Mike Frysinger (thanks!)
> * always pass prefix to depmod.sh to simplify the logic
> * use printf instead of ugly echos in version check

Applied to kbuild.git#kbuild, thanks.

Michal
