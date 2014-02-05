Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaBERle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:41:34 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52805 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaBERlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:41:32 -0500
MIME-Version: 1.0
In-Reply-To: <52F26F53.20408@ti.com>
References: <1391612769-27890-1-git-send-email-illia.smyrnov@globallogic.com>
	<52F26F53.20408@ti.com>
Date: Wed, 5 Feb 2014 11:41:31 -0600
X-Google-Sender-Auth: fJXs6dbdHOYmb0p1yWT6qYa676A
Message-ID: <CAGo_u6qt2qqsxRSdJM26g6_UHObTQQTyPin0fU_1fOViAqW8Lg@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP4: hwmod: Fix SOFTRESET logic for OMAP4
From: Nishanth Menon <nm@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>, Dan Murphy <dmurphy@ti.com>
Cc: Illia Smyrnov <illia.smyrnov@globallogic.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Roger Quadros <rogerq@ti.com>, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-05 Grygorii Strashko <grygorii.strashko@ti.com>:
> Hi All,
> On 02/05/2014 05:06 PM, Illia Smyrnov wrote:
>> Commit 313a76e (ARM: OMAP2+: hwmod: Fix SOFTRESET logic) introduced
>> softreset bit cleaning right after set one. It is caused L3 error for
>> OMAP4 ISS because ISS register write occurs when ISS reset process is in
>> progress. Avoid this situation by cleaning softreset bit later, when reset
>> process is successfully finished.
>
> I'd like to mention that this issue has been caught while upgrading
> custom Linux Kernel 3.4 to the last Stable Kernel linux-3.4.y.
> So, the same OMAP4+ functionality can be broken in all Stable trees
> where commit "ARM: OMAP2+: hwmod: Fix SOFTRESET logic" was merged to.
>
> On OMAP4+ we should always try to wait until IP reset is finished before proceed.
>
> Reviewed-by: "Grygorii Strashko <grygorii.strashko@ti.com>"
>
> Error log example (k3.4):
>

Thanks - I for a moment thought it was on newer kernels :).

Looping in Dan who is currently looking at reset driver replacement
for existing hwmod based reset solution.

Regards,
Nishanth Menon
