Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934704Ab3FSMNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:13:14 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56360 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934678Ab3FSMNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <4881796E12491D4BB15146FE0209CE643F5F0910@DE02WEMBXB.internal.synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CACxGe6uHx4KdZRgAyL-wQ2GurojAH0eTa6YRCoSuCg89BAvBTA@mail.gmail.com>
	<CAHTX3dKPWg35Az8eE45AGriPZh2G6LLaQMynhFPKSZ+7UvM=9g@mail.gmail.com>
	<201302121725.07641.arnd@arndb.de>
	<4881796E12491D4BB15146FE0209CE643F5F0910@DE02WEMBXB.internal.synopsys.com>
Date: Wed, 19 Jun 2013 15:13:11 +0300
Message-ID: <CAHp75Vd_23-6F=U33GPwmKPrS==+a=qTodynUM12EiOBT-xBdQ@mail.gmail.com>
Subject: Re: xsysace driver support on arches other than PPC/Microblaze
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "dahinds@users.sourceforge.net" <dahinds@users.sourceforge.net>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:56 AM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:
> Hi all,
>
> I've been trying to get "xsysace" driver working properly on ARC
> architecture.
> And I was able to get it built and running, but it required me to do 2
> changes - please refer to description below. Now I'd like to get this
> driver working for me righ from upstream sources and this is where my
> questions appear.
>
> While in general I believe any device driver should be easily build and
> then used on virtually any architecture I faced 2 issues with "xsysace":
>
> 1. It uses PPC/Microblaze specific accessors "{in|out}_{le|be}16".
> I sent a patch to this mailing list which replaces these custom
> accessors with common "ioread16{|be}" but a long discussion silently
> ended up with nothing (at least for proposed patch).
> Patch and discussion is available here:
> https://patchwork.kernel.org/patch/2062701/
>
> 2. Inverted logic in "ace_data{in|out}_{be|le}16".
> For example in "ace_dataout_le16" "out_be16" accessor is used which
> simply doesn't work for ARC. We need to have "le" accessor in "le"
> function and vice versa. Implementation of "be" ARC accessor with
> inverted logic doesn't help. Because "ace_{in|out}_{be|le}16" uses plain
> logic.
>
> So I'm wondering what is a best way for me to proceed?
>
> For (1) we may implement custom "{in|out}_{le|be}16" accessors, but is
> it a good way to go?
> For (2) I may expect that plain change of used accessor from "le" to
> "be" will break "xsysace" on PPC/Micropblaze.

If you have a way to detect endianess run-time then you have to
introduce kinda ops structure

struct access {
 .read = read_func(),
 .write = write_func(),
};

ops_le = {...};
ops_be = {...};

And provide a pointer to the chosen structure.

If there no posibility to get it run-time, use kernel config option.

I wonder if there is any "modern" way to do such things.

--
With Best Regards,
Andy Shevchenko
