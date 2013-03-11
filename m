Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3CKPDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CKPDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:03:17 -0400
Date: Mon, 11 Mar 2013 11:02:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311150256.GC8482@redhat.com>
References: <513D52BA.3070206@redhat.com>
 <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311144853.GB8482@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:48:53AM -0400, Vivek Goyal wrote:
> On Sun, Mar 10, 2013 at 09:56:57PM -0700, Yinghai Lu wrote:
> > Current code does not set low range for crashkernel if the user
> > does not specify that.
> > 
> > That cause regressions on system that does not support intel_iommu
> > properly.
> > 
> > Chao said that his system does work well on 3.8 without extra parameter.
> > even iommu does not work with kdump.
> > 
> > Set crashkernel_low automatically if the user does not specify that.
> > 
> > For system that does support IOMMU with kdump properly, user could
> > specify crashkernel_low=0 to save that 72M low ram.
> > 
> 
> Hi Yinghai,
> 
> Had a question about crashkernel_auto_low. So this is the amount of
> memory rerved under 4G. I am not very clear about the semantics here.
> 
> So by default memory wil always come from areas above 4G (when
> crashkernel=X specified) and if user needs reserveation in lower memory
> area, it needs to be sepcified explicitly using crashkernel_low?
> 
> But will that not break the case of exising bzImage which are 32bit.
> They currently work if I specify crashkernel=256M. Now suddenly memory
> will come from higher addresses and 32bit bzImage can't be loaded there.
> Or I understood the syntax part wrong.
> 

IOW, wouldn't it be better that crashkernel=X first tries to find
requested amount of memory in lowest memory area available/possible.

Thanks
Vivek
