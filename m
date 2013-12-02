Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3LBCdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 21:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab3LBCdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 21:33:53 -0500
Date: Mon, 2 Dec 2013 10:32:52 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, greg@kroah.com, toshi.kani@hp.com
Subject: Re: [PATCH v4 00/12] kexec kernel efi runtime support
Message-ID: <20131202023252.GB3999@dhcp-16-126.nay.redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <20131127125003.GG18170@console-pimps.org>
 <20131128020840.GB4282@dhcp-16-126.nay.redhat.com>
 <20131129082822.GA4186@dhcp-16-126.nay.redhat.com>
 <20131129170235.GG4266@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131129170235.GG4266@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/13 at 06:02pm, Borislav Petkov wrote:
> On Fri, Nov 29, 2013 at 04:28:22PM +0800, Dave Young wrote:
> > I think for anyone who are using early_memremap should know this is a
> > normal kernel memory instead of real __iomem
> 
> You can never ever assume that people are using kernel interfaces
> correctly.

But the semantic of early_memreamp should be that it will just return
a normal memory pointer instead of iomem so the fix to convert the internal
implementation to return a __force __kernel make sense to me.

For iounmap I think since we have early_memremap, we have reason to add
early_memunmap() so sparse will be happy.

Thanks
Dave
