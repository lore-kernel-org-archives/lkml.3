Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab3CYGHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:07:23 -0400
Received: from ozlabs.org ([203.10.76.45]:37504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757607Ab3CYGHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:07:22 -0400
From: Michael Neuling <mikey@neuling.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, matt@ozlabs.org,
        imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC:kernel: make additional room in exception vector area
In-reply-to: <20130325161435.ffff94805826bc7cad2c7de4@canb.auug.org.au>
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com> <514AA0D9.1090509@asianux.com> <10123.1363906486@ale.ozlabs.ibm.com> <514C0061.8080004@asianux.com> <29457.1364169818@ale.ozlabs.ibm.com> <514FA8F3.1030102@asianux.com> <20130325161435.ffff94805826bc7cad2c7de4@canb.auug.org.au>
Comments: In-reply-to Stephen Rothwell <sfr@canb.auug.org.au>
   message dated "Mon, 25 Mar 2013 16:14:35 +1100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 17:07:17 +1100
Message-ID: <5944.1364191637@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Mon, 25 Mar 2013 09:31:31 +0800 Chen Gang <gang.chen@asianux.com> wrote:
> >
> >   The FWNMI region is fixed at 0x7000 and the vector are now overflowing
> >   that with allmodconfig. Fix that by moving slb_miss_realmode code out
> >   of that region as it doesn't need to be that close to the call sites
> >   (it is a _GLOBAL function)
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  arch/powerpc/kernel/exceptions-64s.S |  144 +++++++++++++++++-----------------
> >  1 files changed, 72 insertions(+), 72 deletions(-)
> 
> Thanks, Chen,
> 
> I have applied this to linux-next today and pending the builds overnight,
> will send it to Linus tomorrow or Wednesday.

sfr,

FYI you're gonna need this one also to make allmodconfig work.

  http://patchwork.ozlabs.org/patch/230244/

Mikey
