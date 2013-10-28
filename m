Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3J1BTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 21:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab3J1BTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 21:19:14 -0400
Date: Mon, 28 Oct 2013 09:18:24 +0800
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org
Subject: Re: [patch 2/6] x86 efi: reserve boot service fix
Message-ID: <20131028011824.GD4397@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.924386710@dhcp-16-126.nay.redhat.com>
 <20131027105009.GA21868@pd.tnic>
 <20131027203058.GE1982@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027203058.GE1982@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/13 at 08:30pm, Matt Fleming wrote:
> On Sun, 27 Oct, at 11:50:09AM, Borislav Petkov wrote:
> > On Sun, Oct 27, 2013 at 11:47:15AM +0800, dyoung@redhat.com wrote:
> > > Current code check boot service region with kernel text region by: 
> > > start+size >= __pa_symbol(_text)
> > > The end of the above region should be start + size - 1 instead.
> > > 
> > > I see this problem in ovmf + Fedora 19 grub boot:
> > > text start: 1000000 md start: 800000 md size: 800000
> > > 
> > > Signed-off-by: Dave Young <dyoung@redhat.com>
> > 
> > Acked-by: Borislav Petkov <bp@suse.de>
> > 
> > Btw, Matt, this being a bugfix and all, shouldn't it be tagged for
> > stable?
> 
> Well that depends. Dave, am I correct in thinking that you only noticed
> this bug when writing kexec support? I'm inclined not to bother with a
> stable tag if no one has ever noticed any fallout from this bug until
> now.

There should be some people see below message with non-kexec kernel:
"Could not reserve boot range ..."
But it's hard for them to notice the bad functionality because it's only
one mem range which might be not the boot range what SetVirtualAddressMap need
