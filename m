Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3CRTF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:05:26 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36063 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab3CRTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130318153348.GA25806@redhat.com>
References: <20130311182655.GB12107@redhat.com>
	<513E2695.3080707@zytor.com>
	<CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
	<513E28B8.3000502@zytor.com>
	<20130311191031.GD12107@redhat.com>
	<CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
	<20130311193824.GA14738@redhat.com>
	<CAE9FiQUFaA05-Lujn2U01YDCkUo3tady_ZJxhdEDpfR8sLrXMA@mail.gmail.com>
	<CAE9FiQVP2NYV_6XvWEoLHYz8R_Zvueq6zqhh1cKq85geRwWzyA@mail.gmail.com>
	<20130318144603.GA20743@redhat.com>
	<20130318153348.GA25806@redhat.com>
Date: Mon, 18 Mar 2013 12:05:24 -0700
X-Google-Sender-Auth: NYiK1iPjzhScSjU-Vgq4nxdppyY
Message-ID: <CAE9FiQUEf3JriFoSGtG+xzzuagyf_8Rkd9Mc-0uKe=ivYxgE=Q@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 8:33 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Thinking more about it, if ongoing DMA is an issue, then setting up
> software iotlb in those areas is also prone to being overwritten by
> those DMAs. Hence, reserving memory low where no DMA is setup by first
> kernel, seems somewhat safer.

So stick with crashkernel_low ? aka if system does not support iommu
with kdump, they need to append
crashkernel_low in first kernel.

I think that could be way to force vendor to double check to find out
why their system does not support
iommu with kdump.

BTW, our systems do support iommu with kdump without problem.

Thanks

Yinghai
