Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3GVJp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:45:57 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:56348 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3GVJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 22 Jul 2013 15:15:14 +0530
Message-ID: <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html

... and the patches were rejected.  Lennart says that UML providing
/dev/tty* is wrong, and that UML should call them /dev/hvc* (or
something).  Can we do something about the situation?  Can we remove
/dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?

Thanks.

Lennart Poettering wrote:
> UML shouldn't be penalized for not implementing some terminal emulation,
> but it should be penalized for doing so under the label of "VT support",
> which it simply is not providing.
>
> They can call their ttys any way they want. If the call them
> /dev/tty[1..64] however, then they need to implement the VC
> interfaces. All of them.
>
> Also note that some hypervisors implement /dev/hvc0, /dev/xvc0,
> /dev/hvsi0 and suchlike. Theser are also ttys, which are used for
> interfacing in a VT-like way the virtual machines. But they do not claim
> to ve the real VT, they hence picked different tty names.
>
> UML should follow the same route: pick some name you like, or even
> better, pick one of the existing hypervisor tty names if the interface
> and usecase is the same, but do not use /dev/tty[1..64], because that is
> the VT subsystem.
>
> systemd handles the hvc0, xvc0, hvsi0 automatically already. We'd be
> happy if UML could make use of the same logic.
