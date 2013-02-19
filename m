Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934799Ab3BSWv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:51:59 -0500
Received: from ares07.inai.de ([5.9.24.206]:54794 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694Ab3BSWv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:51:57 -0500
Date: Tue, 19 Feb 2013 23:51:56 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: Re: kconfig-frontends-3.8.0.0 release
In-Reply-To: <201302192314.15995.yann.morin.1998@free.fr>
Message-ID: <alpine.LNX.2.01.1302192328280.5517@nerf07.vanv.qr>
References: <201302192314.15995.yann.morin.1998@free.fr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2013-02-19 23:14, Yann E. MORIN wrote:
>I'm pleased to announce the release of kconfig-frontends 3.8.0.0!
>Go download it there:
>    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.8.0.0.tar.xz
>    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.8.0.0.tar.bz2

This seems to install

	/usr/bin/conf   
	/usr/bin/diff   
	/usr/bin/gettext
	/usr/bin/merge
	/usr/bin/tweak

Which conflicts quite hard with various preexisting system packages.

	$ rpm -qf /usr/bin/diff
	diffutils-3.2-2.1.2.x86_64
	$ rpm -qf /usr/bin/gettext
	gettext-runtime-0.18.1.1-15.2.2.x86_64
	$ rpm -qf /usr/bin/merge
	rcs-5.8-1011.1.2.x86_64

You need to give your binaries better names -- or a separate path
(like /usr/libexec/kconfig-frontends/{conf,diff,gettext,...} by
way of  pkglibexec_PROGRAMS = conf diff gettext...)
