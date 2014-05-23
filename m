Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaEWOHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:07:20 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:65204 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEWOHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:07:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 2/2] of: Stop naming platform_device using dcr address
Date: Fri, 23 May 2014 16:07:08 +0200
Message-ID: <4587381.5n3eMGkKaq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400801769-4506-3-git-send-email-grant.likely@linaro.org>
References: <1400801769-4506-1-git-send-email-grant.likely@linaro.org> <1400801769-4506-3-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:B1Fe6dHzIj7a9DLrZBmAK7Y71WDQBITPDU/fe3F1H62
 Ly47GBYdJMmEVjAAib/B7LoHWowSaC7PKm95IJ0zqrEcoDCRhJ
 bJ+qkBFYaX1UR9RAfeqv6ERSM7lpX3O99D1SMIPgGanmM0TN0g
 Gtmeb0HL6p/QOdoremm2b1U2WcK0fJtIqTwlW5g17H1NQjdyg1
 q1YLaSfafhG6BJf9xpLNB/4xmtQVbxFTMjYfE5D9wlnlZe2PdQ
 5QKlC8QUqu62WF6TvgosSToCeuruUhZsI2qMy1dpdjBKOLyTgJ
 N3V2mHJJug31Tyarja70NGJlcvjqwkPqNpnzsQrwCYRkAfiwf6
 HIqGEf0OocI5F8Si28lQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 May 2014 08:36:09 Grant Likely wrote:
> There is now a way to ensure all platform devices get a unique name when
> populated from the device tree, and the DCR_NATIVE code path is broken
> anyway. PowerPC Cell (PS3) is the only platform that actually uses this
> path.  Most likely nobody will notice if it is killed. Remove the code
> and associated ugly #ifdef.
> 
> The user-visible impact of this patch is that any DCR device on Cell
> will get a new name in the /sys/devices hierarchy.

Isn't this used on all ppc440+ as well?

I don't think PS3 has it either, it should only be the second generation
Cell blade doing this, which uses ppc440-derived I/O devices.

We will probably see a bunch of the same devices on APM's X-gene ARM64
machines as well, but we don't have to maintain a stable device name for
those yet.

	Arnd
