Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3AKKEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:04:11 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:43776 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754014Ab3AKKEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:04:09 -0500
Date: Fri, 11 Jan 2013 10:03:57 +0000
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the signal tree with the arm64 tree
Message-ID: <20130111100357.GA12977@mudshark.cambridge.arm.com>
References: <20130111154617.cab6a8d1ff13a4f200969b9d@canb.auug.org.au>
 <20130111093602.GB13405@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111093602.GB13405@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 09:36:02AM +0000, Catalin Marinas wrote:
> Hi Stephen,
> 
> On Fri, Jan 11, 2013 at 04:46:17AM +0000, Stephen Rothwell wrote:
> > Today's linux-next merge of the signal tree got a conflict in
> > arch/arm64/kernel/signal32.c between commits 068f1bb36cf1 ("arm64:
> > compat: include sa_restorer in old action from rt_sigaction") and
> > efed4d52e39f ("arm64: compat: ensure access_ok checks are performed on
> > user structures") from the arm64 tree and various commits from the signal
> > tree.
> > 
> > The latter removes the code modified by the former, so I did that.
> 
> I think the fix is fine. I'll give Al's patches a test and I can
> probably drop Will's patches.

Yup, although it looks like we need to #define __ARCH_HAS_SA_RESTORER for
compat_sys_rt_sigaction.

Will
