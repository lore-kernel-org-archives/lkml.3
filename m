Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaLHTlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:41:31 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:65508 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbaLHTl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:41:29 -0500
Message-ID: <1418067685.2058.27.camel@x220>
Subject: Re: [PATCH 2/3] kconfig: remove undocumented type definition alias
 'boolean'
From: Paul Bolle <pebolle@tiscali.nl>
To: Christoph Jaeger <cj@linux.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Date: Mon, 08 Dec 2014 20:41:25 +0100
In-Reply-To: <5485F923.3090301@redhat.com>
References: <cover.1418003065.git.cj@linux.com>
	  <1539c3778a0f3533942f69540a9b5b3d1f965bdc.1418003065.git.cj@linux.com>
	  <1418064660.2058.11.camel@x220> <1418066039.2058.19.camel@x220>
	 <5485F923.3090301@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2014 19:41:25.0398 (UTC) FILETIME=[F3CCDB60:01D0131E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-08 at 20:16 +0100, Daniel Borkmann wrote:
> On 12/08/2014 08:13 PM, Paul Bolle wrote:
> > On Mon, 2014-12-08 at 19:51 +0100, Paul Bolle wrote:
> >> This doesn't apply on next-20141208. What tree did you base this on?
> >
> > I got it to apply on next-20141208 by dropping the hunk for
> > arch/cris/arch-v32/drivers/Kconfig and by making (trivial) context
> > changes to the hunks for init/Kconfig and net/Kconfig.
> >
> > (My experience with actual maintainers is that they won't bother to do
> > that. Anyhow, Kconfig is basically unmaintained. And I don't know which
> > tree one should base ones Kconfig patches on.)
> 
> Well, I guess if in doubt then this could go into Andrew's tree. :)
> 
> > I'll muddle along...

Checking this on the in tree defconfig files gave me a few hundred, it
seems, errors like:
    net/switchdev/Kconfig:7: syntax error
    net/switchdev/Kconfig:6: unknown option "boolean"
    drivers/hwmon/pmbus/Kconfig:61: syntax error
    drivers/hwmon/pmbus/Kconfig:60: unknown option "boolean"
    drivers/usb/gadget/Kconfig:373: syntax error
    drivers/usb/gadget/Kconfig:372: unknown option "boolean" 
    drivers/usb/gadget/Kconfig:386: syntax error
    drivers/usb/gadget/Kconfig:385: unknown option "boolean"
    drivers/usb/gadget/Kconfig:404: syntax error
    drivers/usb/gadget/Kconfig:403: unknown option "boolean"
    drivers/usb/gadget/Kconfig:418: syntax error
    drivers/usb/gadget/Kconfig:417: unknown option "boolean"
    make[1]: *** [oldconfig] Error 1
    make: *** [oldconfig] Error 2

I assume these are uses of "boolean" added by trees merged in
next-20141208 after the tree that you based your patch on.

Well, it seems the treewide "boolean" cleanup should be done first.
Removing support for "boolean" could than be a second, separate step.
Just to ease review.

Thanks,


Paul Bolle

