Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaGQDlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:41:19 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:36298 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbaGQDlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:41:17 -0400
Date: Thu, 17 Jul 2014 12:40:46 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/6] samples: use uapiprogs support for seccomp
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20140716103120.GA4710@ravnborg.org>
References: <20140716184351.AC2E.AA925319@jp.panasonic.com> <20140716103120.GA4710@ravnborg.org>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140717124046.0EC9.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jul 2014 12:31:21 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> > How can I build hostprogs for the same host as the kernel?
> > (I mean, how can I override $(HOSTCC) for cross-compiling ?)
> 
> One way to do this:
> 
> make ARCH=sparc CROSS_COMPILE=sparc-leon-linux-gnu- HOSTCC=sparc-leon-linux-gnu-gcc
> 
> Notice that I override HOSTCC as part of the make comand line.
> This allows me to override the "=" assignment in the top-level Makefile.
> 
> But then my build breaks as fixdep do not run on my host.
> 
> If you in general want to build a binary for the target then uapiprogs come in handy.
> Only caveat here is that you will be using the exported kernel headers.
> 

Thanks for explaining this. It is clearer to me now.

At first I thought this patch was a clean-up,
but it is indeed a big improvement.
Thanks!



Best Regards
Masahiro Yamada

