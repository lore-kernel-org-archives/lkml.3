Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbaAXNmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:42:31 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:53078 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaAXNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:42:28 -0500
From: Mikael Pettersson <mikpelinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21218.28095.779306.523187@gargle.gargle.HOWL>
Date: Fri, 24 Jan 2014 14:42:23 +0100
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ia64 ski emulator patches
In-Reply-To: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401232041520.16873@file01.intranet.prod.int.rdu2.redhat.com>
X-Mailer: VM 8.1.2 under 24.1.1 (x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka writes:
 > Hi
 > 
 > Here I'm sending some ia64 patches to make it work in the ski emulator. 
 > This has been broken for a long time.

Thanks.  I've recently started running 3.x kernels on ia64 via ski,
but I'm getting random kernel crashes with 3.13.  I'll give your
patches a try shortly.

I've written a few patches to improve other aspects of running the
kernel on ski:
- ski patch to use tun/tap networking (no need to run ski as root)
- ski patch to implement a fixed-frequency ITC (the ITC is currently
  highly variable, completely breaking basic timekeeping)
- kernel patch to turn PAL_HALT_LIGHT into a new SSC_HALT_LIGHT,
  and a corresponing ski patch to pause() on SSC_HALT_LIGHT; this
  together with the fixed-frequency ITC patch allows ski to idle
  with very low host CPU overhead when the guest kernel idles
- kernel patch to bump the RAM size from 130MB to 2GB

I'd be happy to share these patches if there's interest in them.

/Mikael
