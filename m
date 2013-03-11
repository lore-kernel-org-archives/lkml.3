Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3CKUCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:02:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKUCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:02:04 -0400
Message-ID: <513E37B0.6090709@zytor.com>
Date: Mon, 11 Mar 2013 12:59:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <513D52BA.3070206@redhat.com> <1362977817-23297-1-git-send-email-yinghai@kernel.org> <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com> <513E2695.3080707@zytor.com> <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com> <513E28B8.3000502@zytor.com> <87r4jllpfb.fsf@xmission.com> <20130311192247.GG12107@redhat.com>
In-Reply-To: <20130311192247.GG12107@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 12:22 PM, Vivek Goyal wrote:
> 
> So always reserving memory at highest address will break all the cases
> which work without iommu and rely on swiotlb. I think first we need
> to make sure that kdump works reliably with iommu on, and then try
> to move to always reserving memory at higest possible address.
> 

We should clearly always reserve an swiotlb window, *or*, probably much
better, teach the kdump kernel to *make* an swiotlb window (by having a
memory buffer in its reserved memory area into which it copies a chunk
of low memory, just as we do for the bottom megabyte.  If we are already
in low memory that buffer becomes the swiotlb window, no copy necessary.)

	-hpa

