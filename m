Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaIBNnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:43:06 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50124 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaIBNnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:43:03 -0400
Date: Tue, 2 Sep 2014 14:42:58 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Fabio Estevam <festevam@gmail.com>, Nicolas Pitre <nico@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Rob Herring <robherring2@gmail.com>, linux-serial@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, kernel-team@android.com,
        Dave Martin <Dave.Martin@arm.com>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Subject: Re: [STLinux Kernel] [PATCH v11 17/19] serial: asc: Adopt
 readl_/writel_relaxed()
Message-ID: <20140902134257.GA10125@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org>
 <1409662853-29313-18-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409662853-29313-18-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2014, Daniel Thompson wrote:

> The architectures where this peripheral exists (ARM and SH) have expensive
> implementations of writel(), reliant on spin locks and explicit L2 cache
> management. These architectures provide a cheaper writel_relaxed() which
> is much better suited to peripherals that do not perform DMA. The
> situation with readl()/readl_relaxed()is similar although less acute.
> 
> This driver does not use DMA and will be more power efficient and more
> robust (due to absense of spin locks during console I/O) if it uses the
> relaxed variants.
> 
> This change means the driver is no longer portable and therefore no
> longer suitable for compile testing.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> Cc: Maxime Coquelin <maxime.coquelin@st.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: kernel@stlinux.com
> Cc: linux-serial@vger.kernel.org

Acked-by: Peter Griffin <peter.griffin@linaro.org>

