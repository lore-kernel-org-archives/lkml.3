Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaBKUGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:06:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaBKUGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:06:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] of: Turn of_match_node into a static inline when CONFIG_OF isn't set
Date: Tue, 11 Feb 2014 21:06 +0100
Message-ID: <3619654.tQqiI1EfTB@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAMuHMdVkPLe5986hYPApoQr7oJSb6U2P71=nP+9mtvtaskdHXg@mail.gmail.com>
References: <1392122211-11422-1-git-send-email-laurent.pinchart@ideasonboard.com> <20140211180845.GG841@joshc.qualcomm.com> <CAMuHMdVkPLe5986hYPApoQr7oJSb6U2P71=nP+9mtvtaskdHXg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4k+WpWIX5BaqeazRpijIu9C9CbuQfiiGqDRLR56AxYq
 xJd/ki7YiTElQzoG+taqUeyBY/bQtWj76JFNb4FGxWELwiYxfj
 naAIsvhSfXv8vf1TCMexnoGh021aDiebymibyNaT+0GOvcWfZ0
 o6grFKHbeRNCs3hCgMlGdAw2SRSSpYPxdNOOnFrseJvD13Anui
 WmlKHSgZdFvw+8XpEY1hvzAdLR2LOrbRqRssRHVoRviW0t1H2u
 bUB8nGQ2ru2HWrM6jPuYoEMz5IJ5zXXXpmrAYV4D0NVNZkSDTZ
 jDXxp6fI3IaNev/nMZTG5mnfm2BTNJx9lHv1onhGNrXD/citQl
 ow5E7ez5CV69VjcLeM2Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 February 2014 19:29:19 Geert Uytterhoeven wrote:
> On Tue, Feb 11, 2014 at 7:08 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> Ideally, all xxx_device_id look like
> 
>     struct xxx_device_id {
>             ... /* bus-specific ID information */
>             kernel_ulong_t driver_data;
>     };
> 
> This may be formalized in some way, using a base class, but thay may
> require reordering the fields, like:
> 
>     struct base_device_id {
>             kernel_ulong_t driver_data;
>             long id[0];
>     };
> 

You can't reorder the fields because they are shared with user
space in form of the module-init-tools.

	Arnd
