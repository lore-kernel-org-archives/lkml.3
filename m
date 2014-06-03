Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaFCU6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:58:05 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:40724 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaFCU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:58:03 -0400
Date: Tue, 3 Jun 2014 22:57:57 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pointers on debugging my machine not booting
Message-ID: <20140603225757.5dfb2634@neptune.home>
In-Reply-To: <CAPNrq4zJzMwJ2nFwWA3sVc7hr7nYXBRPQomFgZ_1SX+iGxrr0A@mail.gmail.com>
References: <CAPNrq4zJzMwJ2nFwWA3sVc7hr7nYXBRPQomFgZ_1SX+iGxrr0A@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Gideon,

On Thu, 29 May 2014 "Gideon D'souza" <gidisrael@gmail.com> wrote:
> Hey guys,
> 
> So I usually have the latest mainline kernel (on my fedora box) I've
> recently sent it tiny refactoring patches.

What kind of box is it?

> Today, I start my machine and it just doesn't start. I had 3.11, 3.12,
> and a few 3.14 rcs.
> 
> All show up booting, a few lines print on the screen about various
> things it does. At some random point the screen is just black and
> backlit and nothing happens. I tried all kernels, 3.11 and 3.12 and
> official fedora supported kernels. The rest I installed. Even the
> fedora rescue system doesn't work.
> 
> I tried looking into remote debugging linux and keep just getting hits
> on virtual machine options. It's time I left my training wheels and I
> want to debug my actual machine and see what's going on.
> 
> Several of those kernels have debugging support on. I just don't get
> what wire I need to buy, what really is a JTAG and I just need a
> pointer on how to set it up. I have another windows machine and an OSX
> machine around.

JTAG is a debugging interface mostly present on ARM system (develoment
boards, production boards often have no corresponding pin headers).
x86/x86_64 system usually don't have JTAG and serial connectors are
getting less common...
Then there exists some EHCI (yes USB) based debugging interface but
that's all I know about it.

> Any pointers (pun intended) will be greatly appreciated.

If you can hook up a serial console to your box that would maybe help,
at least getting access to what has been shown prior to screen going blank.

For your kernel you would need to add "console=ttyS0" possibly with
a few details on baud-rate (see Documentation/kernel-parameters.txt).

Depending on your GPU and corresponding drivers, adding nouveau.modeset=0
or radeon.modeset=0 or i915.modeset=0 could get your further in case it's
a GPU issue.

Also of interest would be whether your system is still alive or not
(might react to caps-lock, at least for PS2-conected keyboards), how
network interface behaves.

Otherwise sharing the kernel log you see before screen goes black could
give a hint. If it's initializing GPU that breaks your system - black
screen could be just that - checking GPU power supply might be an idea,
especially if kernels that worked in the past don't work anymore.

Critical information is if the "freeze" always happens during kernel
booting or later on when modules are being loaded by your initrd.
In the second case, booting with init=/bin/sh could get you a prompt.

Bruno
