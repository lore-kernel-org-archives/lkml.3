Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab3L1VFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 16:05:11 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:39931 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3L1VFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 16:05:09 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1388264507-5100-1-git-send-email-olof@lixom.net>
References: <1388264507-5100-1-git-send-email-olof@lixom.net>
Date: Sat, 28 Dec 2013 13:05:08 -0800
Message-ID: <CAOesGMhHw-G-T7ZfNsVU92ftOucCNe9shNJtA7SWzqX=dQBQng@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix alignment of secondary cpu spin vars
From: Olof Johansson <olof@lixom.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 1:01 PM, Olof Johansson <olof@lixom.net> wrote:
> Commit 5c0484e25ec0 ('powerpc: Endian safe trampoline') resulted in
> losing proper alignment of the spinlock variables used when booting
> secondary CPUs, causing some quite odd issues with failing to boot on
> PA Semi-based systems.
>
> This showed itself on ppc64_defconfig, but not on pasemi_defconfig,
> so it had gone unnoticed when I initially tested the LE patch set.
>
> Fix is to add explicit alignment instead of relying on good luck. :)
>
> Fixes: 5c0484e25ec0 ('powerpc: Endian safe trampoline')
> Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=67811
> Signed-off-by: Olof Johansson <olof@lixom.net>

Sigh, it's not this after all. I did a clean build with this applied
and still see failures. Something else is (also?) going on here.


-Olof
