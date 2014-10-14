Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaJNUYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 16:24:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53273 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbaJNUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 16:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
	<1413231122-1770-5-git-send-email-kever.yang@rock-chips.com>
Date: Tue, 14 Oct 2014 13:24:03 -0700
X-Google-Sender-Auth: FxOoOzBYHM7bsXVSQEYTsjurKFI
Message-ID: <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kever,

On Mon, Oct 13, 2014 at 1:12 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> +       /*
> +        * We need to soft reset the cpu when we turn off the cpu power domain,
> +        * or else the active processors might be stalled when the individual
> +        * processor is powered down.
> +        */
> +       if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {

I haven't done a full review of this patch, but it seems unlikely that
your uses of read_cpuid_part_number() and read_cpuid_part() in this
patch are correct.  You use both functions and in both cases compare
the results to ARM_CPU_PART_CORTEX_A9.
