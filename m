Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaLSWqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:46:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLSWqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:46:43 -0500
Date: Fri, 19 Dec 2014 14:46:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org, blogic@openwrt.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv4] INPUT: Route keyboard LEDs through the generic LEDs
 layer.
Message-Id: <20141219144641.3a549feb1ee5f2b9400f62cb@linux-foundation.org>
In-Reply-To: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
References: <20141210010214.GZ3074@type.youpi.perso.aquilenet.fr>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014 02:02:14 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> This permits to reassign keyboard LEDs to something else than keyboard "leds"
> state, by adding keyboard led and modifier triggers connected to a series
> of VT input LEDs, themselves connected to VT input triggers, which
> per-input device LEDs use by default.  Userland can thus easily change the LED
> behavior of (a priori) all input devices, or of particular input devices.
> 
> This also permits to fix #7063 from userland by using a modifier to implement
> proper CapsLock behavior and have the keyboard caps lock led show that modifier
> state.
> 
> [ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
> [blogic@openwrt.org: CONFIG_INPUT_LEDS stubs should be static inline]
> [akpm@linux-foundation.org: remove unneeded `extern', fix comment layout]
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Signed-off-by: Evan Broder <evan@ebroder.net>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> Tested-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> Signed-off-by: John Crispin <blogic@openwrt.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> Changed in this version:
> - Use kcalloc instead of kzalloc
> - to avoid any mutex order violation, defer LED update into a work callback.

Confused.  This patch is identical to the one that's presently in -mm.
