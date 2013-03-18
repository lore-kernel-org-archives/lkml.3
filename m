Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab3CRUA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab3CRUA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:00:56 -0400
Date: Mon, 18 Mar 2013 16:00:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130318200048.GJ20743@redhat.com>
References: <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <20130311191031.GD12107@redhat.com>
 <CAE9FiQUxmipKJfUsZdN+J6wGR66VKfLQ8+z41yd3TCJxXTyDRA@mail.gmail.com>
 <20130311193824.GA14738@redhat.com>
 <CAE9FiQUFaA05-Lujn2U01YDCkUo3tady_ZJxhdEDpfR8sLrXMA@mail.gmail.com>
 <CAE9FiQVP2NYV_6XvWEoLHYz8R_Zvueq6zqhh1cKq85geRwWzyA@mail.gmail.com>
 <20130318144603.GA20743@redhat.com>
 <20130318153348.GA25806@redhat.com>
 <514766B7.4070303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514766B7.4070303@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 12:10:47PM -0700, H. Peter Anvin wrote:
> On 03/18/2013 08:33 AM, Vivek Goyal wrote:
> > 
> > Thinking more about it, if ongoing DMA is an issue, then setting up
> > software iotlb in those areas is also prone to being overwritten by
> > those DMAs. Hence, reserving memory low where no DMA is setup by first
> > kernel, seems somewhat safer.
> > 
> 
> Agreed.  We really should reserve some memory low.

So which approach do you like for reserving some memory low.

- User specifies crashkernel_low=X to reserve some memory. Biggest problem
  here is how does user know how much memory is required for setting up
  swiotlb.

- Take yinghai's patch where by default low memory for swiotlb is reserved
  and a user need to opt out of it using crashkernel_low=0 if system has
  iommu enabled.

- crashkernel=X by default first looks for specified memory in low
  memory area.


I kind of like yinghai's approach. It is little wasteful of memory when
memory is reserved high but atleast user does not have know how much memory
to reserve low it works both when memory is reserved low (system does
not have any RAM mapped above 4G) and when memory is reserved high.

Thanks
Vivek
