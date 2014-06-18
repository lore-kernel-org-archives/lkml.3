Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaFRRzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:55:04 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60235 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaFRRzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:55:02 -0400
MIME-Version: 1.0
In-Reply-To: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
Date: Wed, 18 Jun 2014 10:55:01 -0700
Message-ID: <CAGa+x85P-M3qUD6L=kezkiQ1NJymEZ9P=u2ANUZJu2b3F+o5LA@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8 kernels
From: Kevin Hilman <khilman@linaro.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Nico Pitre <nico@fluxnic.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 9:27 AM, Taras Kondratiuk
<taras.kondratiuk@linaro.org> wrote:
> From: Nico Pitre <nico@fluxnic.net>
>
> All known BE8-capable systems have LE bootloaders, so we need to ensure
> that the magic number and image start/end values are in little endian
> format.
>
> [ben.dooks@codethink.co.uk: from nico's original email on this subject]
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> [taras.kondratiuk@linaro.org: removed lds.S->lds rule, added target to extra-y]
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>

This patch has now hit -next (as of next-20140618) and I noticed all
my big-endian boot tests failed[1].  Turns out they failed because I'm
deciding whether to pass a big-endian or little-endian initramfs based
on the magic number of the zImage.  Since it's now always little
endian, even the big-endian kernels were boot tested with a little
endian initramfs.  And guess what.... they failed.

I like this patch for several reasons, including the fact that
u-boot's bootz support checks the magic number and failed before this
patch.

All of that to say, with this patch applied, I need a new (and
reliable) way to determine the endianness of a kernel just by looking
at the zImage.  Recommendations welcome.

Thanks,

Kevin

[1] http://lists.linaro.org/pipermail/kernel-build-reports/2014-June/004059.html
