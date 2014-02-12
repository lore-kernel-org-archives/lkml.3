Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbaBLSSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:18:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaBLSSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:18:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Cooper <jason@lakedaemon.net>, keescook@chromium.org,
        devicetree@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Date: Wed, 12 Feb 2014 19:17:41 +0100
Message-ID: <1571508.yGAAZ8TNH0@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140212174554.GM27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> <201402121251.06280.arnd@arndb.de> <20140212174554.GM27395@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:pTHPf7i0cqyPy1iRvo/Fj42qqKB2VrMD/KvP0fx42pa
 D10D41X3C8SC8O1cYgwVBmgjoU+NipvOu7yXaLT+tdbCHpoAMA
 NTdxBposXALystAARESGcOqMS0aB9OTdbCO2R8FCRcPWPNR+yX
 RNsefXoykbQcqTjeTcOX5lkJsL0PE7kzvqFkj3U/fkv1z/TsfH
 HUYpJIcM0kTOqo7bko6aBqNc3JdTJUQZE/nol4wh+gtNYGte3N
 I/rWJxbThi3+TFBE0HuEkhcymsi37e3e22RCtwNHtMVTMVmn2v
 /sJJVmmHVgHke/d5YLuBdilHnuEenRMy6lbD4BJ4VjZrwVujmm
 HKAcKj1GCF+HHS4agSWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014 12:45:54 Jason Cooper wrote:
> I brought this up at last weeks devicetree irc meeting.  My goal is to
> provide early randomness for kaslr on ARM.  Currently, my idea is modify
> the init script to save an additional random seed from /dev/urandom to
> /boot/random-seed.
> 
> The bootloader would then load this file into ram, and pass the
> address/size to the kernel either via dt, or commandline.  kaslr (run in
> the decompressor) would consume some of this randomness, and then
> random.c would consume the rest in a non-crediting initialization.

I like the idea, but wouldn't it be easier to pass actual random data
using DT, rather than the address/size? That way we could even
use the same DT binding for passing randomness from the bootloader,
whereever it may have found that.

If the bootloader has internet connectivity, it could even mix in
some data from http://www.random.org/cgi-bin/randbyte?nbytes=256&format=f
;-)

	Arnd
