Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3CKURm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab3CKURd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:33 -0400
Date: Mon, 11 Mar 2013 16:17:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, WANG Chao <chaowang@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311201725.GD14738@redhat.com>
References: <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <87r4jllpfb.fsf@xmission.com>
 <20130311192247.GG12107@redhat.com>
 <513E37B0.6090709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E37B0.6090709@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:59:44PM -0700, H. Peter Anvin wrote:
> On 03/11/2013 12:22 PM, Vivek Goyal wrote:
> > 
> > So always reserving memory at highest address will break all the cases
> > which work without iommu and rely on swiotlb. I think first we need
> > to make sure that kdump works reliably with iommu on, and then try
> > to move to always reserving memory at higest possible address.
> > 
> 
> We should clearly always reserve an swiotlb window, *or*, probably much
> better, teach the kdump kernel to *make* an swiotlb window (by having a
> memory buffer in its reserved memory area into which it copies a chunk
> of low memory, just as we do for the bottom megabyte.  If we are already
> in low memory that buffer becomes the swiotlb window, no copy necessary.)

This sounds like a good idea. It will require exporting how much memory
should be needed for swiotlb. And then kexec-tools should be able to 
backup that memory area and make that memory available to second kernel.

Thanks
Vivek
