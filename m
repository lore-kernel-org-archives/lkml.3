Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab3GCIyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:54:50 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27271 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab3GCIyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:54:47 -0400
Date: Wed, 3 Jul 2013 10:54:04 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] pinctrl: elaborate a bit on arrangements in doc
Message-ID: <20130703085403.GC19130@ab42.lan>
References: <1372326887-6497-1-git-send-email-linus.walleij@stericsson.com>
 <51CCB611.6010709@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51CCB611.6010709@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:00:49PM -0600, Stephen Warren wrote:
> On 06/27/2013 03:54 AM, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> [...]
> > +From a kernel point of view, however, these are different aspects of the
> > +hardware and shall be put into different subsystems.
> > +
> > +Electrical properties of the pin such as biasing and drive strength
> > +may be placed at some pin-specific register in all cases or as part
> > +of the GPIO register in case (B) especially. This doesn't mean that such
> > +properties necessarily pertain to what the Linux kernel calls "GPIO".
> 
> Is it worth explaining which Linux subsystem each of the three aspects
> are controlled by. Something like:
> 
> -----
> Registers (or fields within registers) that control electrical
> properties of the pin such as biasing and drive strength should be
> exposed through the pinctrl subsystem, as "pin configuration" settings.
> 
> Registers (or fields within registers) that control muxing of signals
> from various other HW blocks (e.g. I2C, MMC, or GPIO) onto pins should
> be exposed through the pinctrl subssytem, as mux functions.
> 
> Registers (or fields within registers) that control GPIO functionality
> such as setting a GPIO's output value, reading a GPIO's input value, or
> setting GPIO pin direction should be exposed through the GPIO subsystem.
> 
> Depending on the exact HW register design, some functions exposed by the
> GPIO subsystem may call into the pinctrl subsystem in order to
> co-ordinate register settings across HW modules. In particular, this may
> be needed for HW with separate GPIO and pin controller HW modules, where
> e.g. GPIO direction is determined by a register in the pin controller HW
> module rather than the GPIO HW module.
> -----

I agree, this is really worth mentioning in some place, maybe even a
more prominent one than here.

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
