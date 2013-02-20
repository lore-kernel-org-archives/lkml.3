Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934649Ab3BTHxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:53:34 -0500
Received: from ares07.inai.de ([5.9.24.206]:56125 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593Ab3BTHxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:53:32 -0500
Date: Wed, 20 Feb 2013 08:53:29 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kconfig-frontends-3.8.0.0 release
In-Reply-To: <201302200021.31123.yann.morin.1998@free.fr>
Message-ID: <alpine.LNX.2.01.1302200847290.12390@nerf07.vanv.qr>
References: <201302192314.15995.yann.morin.1998@free.fr> <alpine.LNX.2.01.1302192328280.5517@nerf07.vanv.qr> <201302200021.31123.yann.morin.1998@free.fr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2013-02-20 00:21, Yann E. MORIN wrote:
>> This seems to install
>> 	/usr/bin/diff    [...]
>
>By default, the binaries should all ne prefixed with 'kconfig-' to avoid
>such name-clashing (as root, in a fresh debootstrap of squeeze here):

Aha. Seems I hit a peculiarity in rpmbuild. Problem solved, nothing to see. :)

$ grep -A5 -e '^%configure' /usr/lib/rpm/macros
%configure \
  CFLAGS="${CFLAGS:-%optflags}" ; export CFLAGS ; \
  CXXFLAGS="${CXXFLAGS:-%optflags}" ; export CXXFLAGS ; \
  FFLAGS="${FFLAGS:-%optflags}" ; export FFLAGS ; \
  %{_configure} --host=%{_host} --build=%{_build} \\\
        --program-prefix=%{?_program_prefix} \\\
