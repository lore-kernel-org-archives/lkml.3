Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3BHHOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:14:41 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42478 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3BHHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <201302072305.41712.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <5113C818.9050307@synopsys.com> <CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
 <201302072305.41712.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Feb 2013 07:14:20 +0000
X-Google-Sender-Auth: ROqZKg-vcWiuNW9xgFGKYhtPZHQ
Message-ID: <CACxGe6uYdxRCFu5XXXyY4bROiO6kmCcciTPRzhw2MvdLy8kKwA@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 11:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 07 February 2013, Grant Likely wrote:
>> On Thu, Feb 7, 2013 at 3:28 PM, Alexey Brodkin
> Of course, as long as the driver is only ever used to access
> the same non-removable block device and you don't change
> the driver, it does not matter at all whether you swap bytes
> on the data port or not, because they are swapped on both
> read and write, and it's just storage. Only if you try to
> read the device with a "correct" driver, you will see a problem
> if it was written with a "wrong" driver.

It's actually a removable compact flash card interface. I know that
the current big-endian support code is correct because my laptop
doesn't complain about the data.  :-)

g.
