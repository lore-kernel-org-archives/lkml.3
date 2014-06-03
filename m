Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbaFCROn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:14:43 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61127 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaFCROm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140603170244.GA22867@kroah.com>
References: <20140603054434.GB2921@kroah.com>
	<CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
	<20140603170244.GA22867@kroah.com>
Date: Tue, 3 Jun 2014 10:14:41 -0700
X-Google-Sender-Auth: 4oePr0DOhJDSYWrHPY_uyXVEefo
Message-ID: <CA+55aFwMEigYZGeF4sFTSpmnvb8YQ3hOndjNrd9ObL2EdOptgQ@mail.gmail.com>
Subject: Re: [GIT PULL] char/misc driver patches for 3.16-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 10:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> Hm, I got two different bug reports, and this same patch from two
> different people insisting that we broke their drivers with the above
> patches, and asked for this patch to be applied.

So I do think that we might be able to apply this patch, but I think
it needs a *lot* more thought than was obviously spent on it so far.

For example, right now it's actively insecure. Do we care? Maybe we
don't. The user-space uio side presumably is root-owned, and hopefully
trusted.

And what about the unaligned mmio case? Are people somehow
guaranteeing that the regions is page-aligned, even if it isn't
page-sized?

What is the actual hardware in question?

Basically, it's an obvious security issue, and we shouldn't just say
"whatever". But maybe - with lots of commentary about why the security
implications aren't actually bad in _practice_, and why things are
always page-aligned even if they aren't page-sized, we can say "ok,
it's wrong, but we can still do it because xyz".

So I'm mostly unhappy because I didn't see that kind of analysis, not
because the patch might not eventually be ok. A "this breaks my
driver" is nowhere near the kind of thought this needs, I think.

                 Linus
