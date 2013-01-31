Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3AaKhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:37:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3AaKhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:37:40 -0500
Message-ID: <510A4967.5070009@suse.cz>
Date: Thu, 31 Jan 2013 11:37:27 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/1] depmod: pass -P $CONFIG_SYMBOL_PREFIX
References: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1359625303-11842-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.1.2013 10:41, James Hogan wrote:
> On architectures which have symbol prefixes, depmod emits lots of false
> warnings like this:
> 
> WARNING: $module.ko needs unknown symbol $symbol
> 
> This is because depmod isn't being passed the -P <symbol_prefix>
> arguments to specify the symbol prefix to ignore. This option is
> included since the 3.13 release of module-init-tools.
> 
> Update scripts/depmod.sh to take extra arguments which are passed
> through directly to depmod, and update the main Makefile to pass
> -P $(CONFIG_SYMBOL_PREFIX to scripts/depmod.sh, but only if
> CONFIG_SYMBOL_PREFIX is set and non-empty.

OK.


> scripts/depmod.sh also drops the -P arguments if depmod --version
> reports module-init-tools with a version number < 3.13.

You can replace the test with a simple

"$DEPMOD" -P _ --help 2>/dev/null >/dev/null

Michal
