Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3BGOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:40:26 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:32956 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3BGOkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:40:24 -0500
MIME-Version: 1.0
In-Reply-To: <1360186550.2650.4.camel@pasglop>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
 <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com>
 <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop>
 <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com>
 <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com>
 <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop>
 <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop>
 <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com> <1360186550.2650.4.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 7 Feb 2013 14:39:59 +0000
X-Google-Sender-Auth: LKkrLcZuGXi3QkcUas_BhFjTLBY
Message-ID: <CACxGe6uaVsng79Kni=0O_YK330vuqMuPO6=y9Bj=UZpZ0ozaDg@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        dahinds@users.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 9:35 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2013-02-06 at 10:14 +0000, Grant Likely wrote:
>>
>> Huh? That makes no sense. This device out in the wild with both big
>> and little endian bus attachments. You can argue all day that one of
>> them is wrong, but it doesn't matter. It exists, is used, and must be
>> supported.
>
> No. That's where you are VERY wrong. We don't have to support crap and
> arguably shouldn't if that can give an incentive to vendors to fix their
> stuff. If you don't believe me, ask Linus :-)

As far as horrible hardware goes, this device comes no where close to
some of the stuff I've worked on. The driver is self contained. It
doesn't have any nasty hooks into the rest of the kernel and most
importantly it currently *works* and is used.

>>  In fact, the driver already knows about this and figures
>> out at runtime how the device is wired up to the bus. This is not the
>> problem.
>
> Except that this is very gross, especially when you observe that in the
> busted "big endian" case, it has to byteswap the bloody data port.
>
> So you end up having to do that gross hack with separate accessors for
> registers vs. data and not able to use the _rep variants, which also
> means that on platforms like ppc, you end up with a memory barrier on
> every access (or more), which is going to slow things down enormously.

I don't see why the _rep variants aren't usable here. The only reason
I didn't use them when I wrote the driver in the first place was I was
a n00b kernel hacker and I didn't know they were there.

g.
