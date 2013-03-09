Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3CIHWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 02:22:46 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:59686 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab3CIHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 02:22:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130308195324.GE6622@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
	<1360351703-20571-13-git-send-email-yinghai@kernel.org>
	<20130308195324.GE6622@phenom.dumpdata.com>
Date: Fri, 8 Mar 2013 23:22:43 -0800
X-Google-Sender-Auth: cltKcqtfmaGm8KOGOBiHpv_SOig
Message-ID: <CAE9FiQUWxiLtw4xpe-Xt9peCpUMn-vsTHh4hDf=m5xs3pAf7nA@mail.gmail.com>
Subject: Re: [PATCH v2 12/26] x86, irq: Add realloc_irq_and_cfg_at()
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 11:53 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> + * irq_realloc_desc - allocate irq descriptor for irq that is already reserved
>
> Which begs the question - why was it not allocated when it was reserved?

The reasons for not allocating them during reserving:
1. only several pins in ioapic are used, allocate for them pin, will
   waste memory for not used one.
2. relocate later could make sure irq_desc is allocated on local node ram.

Thanks

Yinghai
