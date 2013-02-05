Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3BEXD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:03:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab3BEXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:03:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 5 Feb 2013 23:03:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
In-Reply-To: <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302052303.01795.arnd@arndb.de>
X-Provags-ID: V02:K0:scHYPQ7CIL4/AD7549bQO0WoG3cTzCpGWUlwH7wjBIC
 iBQuIa+kVdlNTNGbrw7pxC5amfpBl+CCPWAlHtiyHXbiO0nFup
 m6dU4OwYgujEM8Ei98nwOHpc985qH6sZ37ZQor+U3mcWyIet07
 yjYyXXZJkzL1PBIGorMMeNMQhi5a4i3zPQIUAYhLQt89oR+M5e
 eoV0gAFHYX2/iwTLOYc17bsz9yMIO7Q6eDVHGzl6gjMs0zU68u
 LV5L/WMEo76+x1+QityxGjO3v/hPgHrBGqopKZCqej5+JlRZy5
 f6LJW9ennmXz+C5PBKa/303Gt2V3nE7c9GuCIq8yZC+eFzvW+q
 coAx+3dbkYBbpUherQXY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013, Michal Simek wrote:
> I want to be sure about this. I have parsed this again with closer look and
> seems to me that ioread32 is equal to readl and iowrite32 to writel.
> Arnd: Am I right?

Correct. On all the architectures you care about (most importantly, not
x86), readl and ioread32 are defined to have the same semantics. There
are a few exceptions where ioread32 provides a wrapper for PCI
PIO accesses that are not memory mapped, making ioread32 slightly
slower than readl, but for all practical purposes you don't have
to worry about it ;-)

	Arnd
