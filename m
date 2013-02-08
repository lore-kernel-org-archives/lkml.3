Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3BHGTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 01:19:53 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:35110 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3BHGTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 01:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <201302072305.41712.arnd@arndb.de>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<5113C818.9050307@synopsys.com>
	<CACxGe6srNmX+qL+5BBFOzTHtQLRcw+4Aqjexy0Y=Vbh3XqPWPA@mail.gmail.com>
	<201302072305.41712.arnd@arndb.de>
Date: Fri, 8 Feb 2013 07:19:51 +0100
X-Google-Sender-Auth: sxlXDrJVZNBPVOwQi7qu5R2djdw
Message-ID: <CAMuHMdV36vSiirvBiiPVdhcqUA+pY60KK2yFfWCp1xXnJX9NPQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 12:05 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> The same is true for the data port. A BE read does the right thing on
>> a BE platform, and LE read on a LE platform. (again, this is all about
>> bus attachment). However, the difference is what is then done with the
>> data.
>
> Well, except that we cannot use the ioread16be_rep function,

ioread16_rep

> which is made for the case where the bus does not swap.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
