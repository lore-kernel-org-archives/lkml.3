Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaJABuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 21:50:10 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:44427 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833AbaJABuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 21:50:09 -0400
Message-ID: <542B5DC2.8020806@hurleysoftware.com>
Date: Tue, 30 Sep 2014 21:49:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Akinobu Mita <akinobu.mita@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>, Don Dutile <ddutile@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        iommu@lists.linux-foundation.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 0/5] enhance DMA CMA on x86
References: <1397567329-3771-1-git-send-email-akinobu.mita@gmail.com> <5426CA0A.7000806@hurleysoftware.com> <CAC5umyhgs8---HZLa7_DOSbqW0uPbLgqTfBweScZSR9oWbG9xg@mail.gmail.com> <54294C0B.1060705@hurleysoftware.com> <CAC5umyjP4OscSC8igVLYPEm-6gqiXt9md46sLu77Vut5UiPb=g@mail.gmail.com> <542ABF77.1020402@hurleysoftware.com> <alpine.DEB.2.11.1410010131380.4455@nanos>
In-Reply-To: <alpine.DEB.2.11.1410010131380.4455@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 07:45 PM, Thomas Gleixner wrote:
> Whether the proposed patchset is the correct solution to support it is
> a completely different question.

This patchset has been in mainline since 3.16 and has already caused
regressions, so the question of whether this is the correct solution has
already been answered.

> So either you stop this right now and help Akinobu to find the proper
> solution 

If this is only a test platform for ARM parts then I don't think it
unreasonable to suggest forking x86 swiotlb support into a iommu=cma
selector that gets DMA mapping working for this test platform and doesn't
cause a bunch of breakage.

Which is different than if the plan is to ship production units for x86;
then a general purpose solution will be required.

As to the good design of a general purpose solution for allocating and
mapping huge order pages, you are certainly more qualified to help Akinobu
than I am.

Regards,
Peter Hurley

