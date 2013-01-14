Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3ANKyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 05:54:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3ANKym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 05:54:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: early init dt for earlyprintk (was Re: [RFC PATCH v1 25/31] ARC: [plat-arcfpga] Hooking up platform to ARC UART)
Date: Mon, 14 Jan 2013 10:54:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Paul Mundt <lethal@linux-sh.org>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <201211071416.08012.arnd@arndb.de> <50F3B54D.7010801@synopsys.com>
In-Reply-To: <50F3B54D.7010801@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301141054.27872.arnd@arndb.de>
X-Provags-ID: V02:K0:lriJZgZbUmNX3HiN9OdVu0bYdLG8015ijRogfdmDAxc
 dNKUepJ4wgvREUDzD3v4lt6PjrJg7kKOMX0MV61rkbPmdsTn7g
 f6hO/swNhUlKkG7l+OSrxsmkwVZOCyAaCAokhGbVbjT/NUEmIM
 EnaaXdp+tZ3Cwb8h7ZfoX9nrK/Ggbj/37gddtQRZWsRROcAv2u
 vmqDlprncND8tG6KnL1RJEUo7qa7HOrDoRSh+Zaps2KXdPDNVI
 //QP+h8jH2/pPDohDYnupisMfcLx0ucUlGmmshBbRC5N9L056O
 4Tv3ru2WLUZnW4PEvY0qGYu3rgipc/GXL0TmpgUeiIV+f7W1fb
 0iKU6cdPeJy3OxohhfQs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013, Vineet Gupta wrote:
> 
> On Wednesday 07 November 2012 07:46 PM, Arnd Bergmann wrote:

> 
> OK, I have DeviceTree infrastructure in place. After wrapping my head around
> irq-domains, the whole thing indeed seems like a nice abstraction. ARC Port
> converted to it and patches to arc-uart driver to that effect posted to serial
> lists.

Ok, very good.

> Couple of things though:
> 
> 1. While I've eliminated the platform_device population for SERIAL_ARC, we still
> need the static resource definitions and aux platform data for
> early_platform_add_devices() for SERIAL_ARC_CONSOLE since it uses the early param
> based driver registration and device probe. AFAIKS, there's no existing way to
> scan a special "earlyprintk" node (from flat tree) which at a minimum contains a
> "reg" property and some device specific platform info. There are only a few  other
> drivers which uses the same design (e.g. tty/serial/sh-sci.c) but they don't seem
> to be DT enabled. Thus in the short term we will have to live with static coding
> for early platform device. Later on we can clean it up - I can take a stab at
> adding earlyprintk based bits to fdt.c - if that makes sense.

There is always a question of how early you want the early printk to be --
the earlier you want it, the more hacks you end up needing.

The early_platform_device infrastructure is not used by a lot of architectures,
so things can get a little hairy. Something you can do though is have an
early_console without a platform_device attached to it, and scan the
device tree for the nodes manually in order to find the registers.
It would be good if we could eventually agree on a common approach for this,
but right now just use whatever works for you.



> 2. We really need a Documentation/dt-for-new-linux-arches.txt, as the existing
> refs - while very helpful - fail to mention subtleties such as you absolutely need
> a intc instance and a default irq domain ..... before the driver can start using
> the DT. Also the board specific callbacks etc are not really fundamental to the DT
> concept (at least I initially thought so) causing a distraction when adding the
> initial implementation. The minimal dynamic device population can very well be
> done in a arch initcall. I'll sum these up in a documentation-for-dummies and
> float around.

Ok, great! That is very much appreciated.

	Arnd
