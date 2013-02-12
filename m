Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657Ab3BLNzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:55:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285Ab3BLNze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:55:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 12 Feb 2013 13:55:25 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <201302121126.10288.arnd@arndb.de> <CAHTX3dKn7iwbHyOnpJ4XiNbK766oqrJW06kH7XrAW2TJtOhehA@mail.gmail.com>
In-Reply-To: <CAHTX3dKn7iwbHyOnpJ4XiNbK766oqrJW06kH7XrAW2TJtOhehA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201302121355.25762.arnd@arndb.de>
X-Provags-ID: V02:K0:hBDITWerx4vpKNzaPsRJq3px1uC5Wofa9bSZiaPkDr8
 PdhK0gRC/qw40ph/OoyTQVNqPzui9AvoNeE/vHBURF5CkgV5se
 2K6BGeKwnRlYinpzPGFM5FfsP5r+f6YYd5S3nAzSWHKbKZdKw1
 8NoD1jcBhfbKG/IuJ9Fe/Ny4HRMdF3qkjfHfDi+vxDqRUbBkRN
 eGbgJog3qbC9MXSnRJdc54cTriss8gU8rx1lefNY54u/hr/vOP
 pLUsWjncG2rCfUNh1/PlMzFjkL+RwtZHxCJZEpMIbx4fiWzSrh
 R07u2pgb1HDM26Xkg9gy3Pkr4Lq+78ug86zMQCqebZFA/rJN7M
 oll6HCYaEHeEuqbaUm9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Michal Simek wrote:
> ok but still there should be well defined how to do it. Let's say
> generic Kconfig option.

You cannot solve it in a generic way, since every device has different
needs. In a single SoC, you may have one device that only ever exists
with little-endian I/O, one that is always wired the same way as the
CPU, one that always swaps endianess and one that exists in two
variants but you know which one you have at compile time.

> Or maybe there is also third option to modified code to use proper writes.

You mean run-time code patching? That is seriously wrong here. As Ben
explained, MMIO is slow by definition, so if you add five cycles for
an indirect function call on every MMIO read, that will not even
be noticeable in the 20µs latency that the read has on the bus.

	Arnd
