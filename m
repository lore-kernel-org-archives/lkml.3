Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3IINZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:25:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab3IINZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:25:40 -0400
From: Thomas Renninger <trenn@suse.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Len Brown <len.brown@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, ACPI: Increase override tables number limit
Date: Mon, 09 Sep 2013 15:25:31 +0200
Message-ID: <3912512.hYKBVDmhoN@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.16-desktop; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1378519680-10490-1-git-send-email-yinghai@kernel.org>
References: <1378519680-10490-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I do not have a problem with this, just for info:

On Friday, September 06, 2013 07:08:00 PM Yinghai Lu wrote:
> Current acpi tables in initrd is limited to 10, that is too small.
> 64 should be good enough as we have 35 sigs and could have several
> SSDT.
The whole mechanism is for debugging only. Nobody would (or should,
there simply is no use case), override all the ACPI tables.
You would either override the APIC table if you try with interrupt 
assignments. Or correct a part in the DSDT and/or SSDT(s) and check if the 
kernel runs smoothly without errors then, etc.

> 
> Two problems in current code prevent us from increasing limit:
> 1. that cpio file info array is put in stack, as every element is 32
>    bytes, could run out of stack if we have that array size to 64.
>    We can move it out from stack, and make it as global and put it in
>    __initdata section.

> 2. early_ioremap only can remap 256k one time. Current code is mapping
>    10 tables one time. If we increase that limit, whole size could be
>    more than 256k, early_ioremap will fail with that.
>    We can map chunks one by one during copying, instead of mapping
>    all them one time.
This problem would persist, because the by far biggest table typically
is the DSDT with several ten thousand lines of code, while the other
tables typically only have some hundred.

        Thomas
