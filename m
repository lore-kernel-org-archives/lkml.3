Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582Ab3DCUi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:38:58 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:47487 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3DCUi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130403174734.GG5939@redhat.com>
References: <20130402180606.GI29506@redhat.com>
	<CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
	<CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
	<20130402191130.GB31760@redhat.com>
	<CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
	<20130402201148.GJ29506@redhat.com>
	<CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
	<20130403131842.GA5939@redhat.com>
	<CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
	<CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
	<20130403174734.GG5939@redhat.com>
Date: Wed, 3 Apr 2013 13:38:56 -0700
X-Google-Sender-Auth: d84PyN1l0lRdpNZodr9ZAbtZ63Y
Message-ID: <CAE9FiQU96BjThKbOGBhc6RHBey2+bvM6J6ZYaLb=xGuwahTuLQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 10:47 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> So what I am saying that all our code is written assuming there is one
> single reserved range. Now if we need to reserve two ranges, then let
> us make it generic to suppoprt multiple ranges instead of hardcoding
> things and assume there can be 2 ranges. That will be a more generic
> solution.

I don't think we have case that we need to support more than two ranges.

We only need to have one big range above 4G, and put second kernel and
initrd in it.
and another low one is only for switotlb or others that will be used by
second kernel.

>
> So how about this.
>
> - In 3.9, just implement crashkernel=X;high. Don't auto reserve any low
>   memory. Support reservation of single range only. It could be either
>   high or low.
>
> - Those who are using iommu, they can use crashkernel=X;high. Old code
>   can continue to use crashkernel=X and get memory reserved in low
>   memory areas.

That will not handle the case: big system that crashkernel=X;high
and kdump does not work with iommu.

>
> - In 3.10 add a feature to support multiple crash reserved ranges.

Again, we only need one high and one low range.
We don't need to support more than two ranges for crash kernel.

Thanks

Yinghai
