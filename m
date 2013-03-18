Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3CROqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:46:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3CROqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:46:11 -0400
Date: Mon, 18 Mar 2013 10:46:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130318144603.GA20743@redhat.com>
References: <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <20130311191031.GD12107@redhat.com>
 <CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
 <20130311193824.GA14738@redhat.com>
 <CAE9FiQUFaA05-Lujn2U01YDCkUo3tady_ZJxhdEDpfR8sLrXMA@mail.gmail.com>
 <CAE9FiQVP2NYV_6XvWEoLHYz8R_Zvueq6zqhh1cKq85geRwWzyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVP2NYV_6XvWEoLHYz8R_Zvueq6zqhh1cKq85geRwWzyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:44:15PM -0700, Yinghai Lu wrote:
> On Mon, Mar 11, 2013 at 12:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Mar 11, 2013 at 12:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >>> No need to use crashkernel_high, we can just cashkernel=X@Y instead.
> >>
> >> crashkernel=X@Y is little different. It assumes user knows the memory
> >> map and location "Y" is fixed. There might not be any memory at "Y".
> >
> > then use crashkernel=4G?
> 
> I re attached -v2 and -v3.
> 
> I'm ok that any one is applied or two get applied all together.
> 
> only affect 64bit
> -v2: try under under 896M, then 4G, then MAXMEM
> -v3: auto set crashkernel_low with swiotlb size.

So, what's the resolution on this issue. Is the verdict that we always
reserve high. Update your kexec-tools to cope with that. For swiotlb
issue, modify kexec-tools to copy low memory in backup region and give
low memory to second kernel for software iotlb?

I am assuming that updating tools will not help with loading and using
of 32bit bzImage. So user needs to use crashkernel=X@Y syntax to cope
with that? (Given the fact that copying code around after crash carries
the greater risk of ongoing DMA on destination location).

Thanks
Vivek
