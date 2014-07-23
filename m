Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaGWGai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:30:38 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62786 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGWGaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140709142333.503a9e39@alan.etchedpixels.co.uk>
References: <1403781875-5425-1-git-send-email-t.figa@samsung.com>
	<20140626113939.GP32514@n2100.arm.linux.org.uk>
	<53AC0BCC.1010608@samsung.com>
	<CAD8Lp45MvDLsxehayx8uuGt3w3O0vGskiFjb1vdvtOyOv2nG2w@mail.gmail.com>
	<20140709142333.503a9e39@alan.etchedpixels.co.uk>
Date: Wed, 23 Jul 2014 07:30:33 +0100
Message-ID: <CAD8Lp47GpiRabx56u5F+qrY=mx_OOj2dOqfQ6_=4TBe=JskDkQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Deterministic UART numbering on Samsung SoCs
From: Daniel Drake <drake@endlessm.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Tomasz Figa <tomasz.figa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 2:23 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
>> I like the sound of going to the standard ttyS notation and only
>> providing ports for ones that exist, but is this userspace-visible
>
> ttyS is 8250 compatible UARTS.
>
> If the Samsung is not an 8250 compatible UART then it doesn't belong as
> ttyS from the kernel perspective.

OK, thanks for pointing that out.

So we stick with the ttySAC namespace. And by doing that, and sticking
to the existing and documented behaviour, it seems like we have
already addressed Russells's concern:

> The problem you're raising is very much the same problem you have when
> there are multiple USB serial devices connected to the machine - you
> just get a bunch of /dev/ttyUSB* devices which are unordered (they can
> change on each boot, or change order if you disconnect and reconnect
> them.)

In this case, we have a dedicated namespace and the path information
is already fully encoded in the device name. The order and number of
ports are fixed, they can't be disconnected and reconnected. There is
no real risk of an additional serial controller driver coming to play
in the ttySAC namespace.

So I think Tomasz's approach is good - although I haven't looked at
the code in detail.

Thanks
Daniel
