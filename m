Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3CDT6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:58:38 -0500
Received: from mout.gmx.net ([212.227.17.20]:57044 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573Ab3CDT6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:58:37 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX194Qbt5UdF4eWTOJWHj+A88mSQzV+gt3kK8geYKuJ
	T/m/g2QqTYf90P
From: Peter =?utf-8?q?H=C3=BCwe?= <PeterHuewe@gmx.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] staging/vt6656: Fix too large integer constant warning on 32-bit
Date: Mon, 4 Mar 2013 20:59:13 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.7; KDE/4.9.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1362426120-18545-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1362426120-18545-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303042059.13394.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. März 2013, 20:42:00 schrieb Geert Uytterhoeven:
> drivers/staging/vt6656/card.c: In function ‘CARDqGetNextTBTT’:
> drivers/staging/vt6656/card.c:793: warning: integer constant is too large
> for ‘unsigned long’ type
> 
> Commit c7b7cad0d8df823ea063c86a54316bbcbfa04a7c ("staging/vt6656: Fix
> sparse warning constant 0xffffffff00000000U is so big it is unsigned long")
> changed the constant to "0xffffffff00000000UL", but that only works on
> 64-bit.  Change it "0xffffffff00000000ULL" to fix it for 32-bit, too.
> 
Thanks - sorry that I had missed this.
I thought I had it compiled on x86 (non64 bit), too.

Reviewed-by: Peter Huewe <peterhuewe@gmx.de>
