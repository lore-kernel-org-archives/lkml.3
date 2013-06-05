Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab3FEVMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:12:22 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:44046 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3FEVMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:18 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1370465793-7997-1-git-send-email-dianders@chromium.org>
References: <1370397539-21653-1-git-send-email-dianders@chromium.org>
	<1370465793-7997-1-git-send-email-dianders@chromium.org>
Date: Wed, 5 Jun 2013 14:12:17 -0700
Message-ID: <CAOesGMhQX9ip=nb9AQa5fcDFRNpZZSxUO0N0GTX051dakWZD9Q@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: exynos: add debug_ll_io_init() call in exynos_init_io()
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Simon Glass <sjg@chromium.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 1:56 PM, Doug Anderson <dianders@chromium.org> wrote:
> If the early MMU mapping of the UART happens to get booted out of the
> TLB between the start of paging_init() and when we finally re-add the
> UART at the very end of s3c_init_cpu(), we'll get a hang at bootup if
> we've got early_printk enabled.  Avoid this hang by calling
> debug_ll_io_init() early.
>
> Without this patch, you can reliably reproduce a hang when early
> printk is enabled by adding flush_tlb_all() at the start of
> exynos_init_io().  After this patch the hang goes away.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>


Kukjin, this seems appropriate for 3.10. Do you have other fixes
queued or should I apply this directly?


-Olof
