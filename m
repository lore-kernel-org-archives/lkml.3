Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3CKVLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab3CKVLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:11:00 -0400
Date: Mon, 11 Mar 2013 17:10:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311211050.GA16843@redhat.com>
References: <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
 <20130311201245.GC14738@redhat.com>
 <513E3C44.9030402@zytor.com>
 <87hakhk6xu.fsf@xmission.com>
 <513E41BD.3030003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E41BD.3030003@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 01:42:37PM -0700, H. Peter Anvin wrote:
> On 03/11/2013 01:38 PM, Eric W. Biederman wrote:
> > 
> > I totally makes sense to figure out how to load a kernel high.  I am not
> > convinced kexec on panic is the best use of that ability.  I would argue
> > that it might be better to figure out how to use a small memory
> > foot-print and try to keep that foot-print from growing.
> > 
> 
> I could not agree more with this.  The whole reason this is a problem is
> because we are talking about hundreds of megabytes of crashkernel.  If
> we can fix *that* problem, we are much better off.

This kind of goal is achievable only if we also restrict how much memory
first kernel can use. Then all the dependent component will be aware of
how severe boot requirements are. And there is no such requirement. It is
just a goal that keep memory bloat to the minimum. But bloat does not mean
that booting is not allowed. To me kdump environment requirement should be
no different. Otherwise enforcing them becomes a challenge.

Thanks
Vivek
