Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab3FEU46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:56:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53077 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab3FEU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130605031536.GA24910@quad.lixom.net>
References: <1370397539-21653-1-git-send-email-dianders@chromium.org>
	<20130605031536.GA24910@quad.lixom.net>
Date: Wed, 5 Jun 2013 13:56:52 -0700
X-Google-Sender-Auth: hzkYs4LTwr58py4erRleEQQCB3E
Message-ID: <CAD=FV=UqLaAWh6pxAXXjcEu+D5ByoCB1V7F8Z2h-Ddq9ObS_6w@mail.gmail.com>
Subject: Re: [PATCH] ARM: samsung: avoid racy early printk at bootup
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Simon Glass <sjg@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof,

On Tue, Jun 4, 2013 at 8:15 PM, Olof Johansson <olof@lixom.net> wrote:
> This seems to be caused by not calling iotable_ini() in exynos_init_io()
> when a device tree is passed into the kernel, thus not setting up the
> mapping for the UART in that case.
>
> I think the solution is instead to map the uart earlier. The window of
> exposure is still there, but much smaller (and similar to how it always
> has been).
>
> In current upstream, if there is no map_io mach_desc entry at all,
> debug_ll_io_init() will be called on all platforms. Seems appropriate
> to call that explicitly before of_scan_flat_dt() in exynos_init_io()
> in this case.

Oh.  Ummm, right.  Yes, debug_ll_io_init() is exactly what's needed
here instead of all the complexity of what I proposed.  New patch
coming shortly.  Thanks!  :)

-Doug
