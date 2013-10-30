Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3J3XXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 19:23:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3J3XXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 19:23:35 -0400
Date: Wed, 30 Oct 2013 16:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH] Fix build without CONFIG_INPUT_LEDS [Was: mmotm
 2013-10-29-16-22 uploaded (input)]
Message-Id: <20131030162334.f4d14c0b1b135cb38dce5dfb@linux-foundation.org>
In-Reply-To: <20131031102012.599a7a256c48feed7832a208@canb.auug.org.au>
References: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com>
	<52706790.9090602@infradead.org>
	<20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
	<20131031102012.599a7a256c48feed7832a208@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct 2013 10:20:12 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Wed, 30 Oct 2013 12:46:24 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> >
> > Randy Dunlap, le Tue 29 Oct 2013 18:57:36 -0700, a __crit :
> > > arc_ps2.c:(.text+0x500): multiple definition of `input_led_connect'
> > 
> > D'oh.  I indeed hadn't tested the inlines, sorry about this.
> > 
> > Andrew, could you add the following patch on top of
> > input-route-kbd-leds-through-the-generic-leds-layer.patch
> > or perhaps rather fold into it?
> > 
> > Samuel
> > 
> > 
> > 
> > Really mark inlines as static inlines, so they are not defined multiple
> > times.
> > 
> > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> I have added that as a fix patch for the akpm-current tree for today.

It needs this as well.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: input-route-kbd-leds-through-the-generic-leds-layer-fix-fix

use IS_ENABLED to pick up CONFIG_INPUT_LEDS=m

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/input.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer-fix-fix
+++ a/include/linux/input.h
@@ -533,7 +533,7 @@ int input_ff_erase(struct input_dev *dev
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
-#ifdef CONFIG_INPUT_LEDS
+#if IS_ENABLED(CONFIG_INPUT_LEDS)
 
 int input_led_connect(struct input_dev *dev);
 void input_led_disconnect(struct input_dev *dev);
_

