Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab3CEUWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:22:34 -0500
Received: from relay1.sgi.com ([192.48.179.29]:56599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3CEUWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:22:32 -0500
Date: Tue, 5 Mar 2013 14:22:29 -0600
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>, hpa@sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: Revert commit 5dcd14ecd4 - breaks EFI boot with SLES11
 elilo.efi
Message-ID: <20130305202229.GW3438@sgi.com>
References: <512FC697.3090608@zytor.com>
 <20130228210910.GD3438@sgi.com>
 <512FC82B.40909@zytor.com>
 <CAE9FiQU3FBwEiC86N1RC8=aMdN09EbUmRcsWP0yof7bmxBhPew@mail.gmail.com>
 <512FE3AE.4070903@zytor.com>
 <20130305081519.GA19165@sgi.com>
 <9bcd6241-37fd-4ae9-a997-2a5da1eaf997@email.android.com>
 <CAE9FiQV2Wk+yiqR8FnNM_L-p1iQFxDwopRzFWTwm6VCkyrbuoQ@mail.gmail.com>
 <20130305195229.GS3438@sgi.com>
 <CAE9FiQX_+WO4Zr7TGWdjCNo_cdk+aSAmRNzpPUW_NxirnMEBCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQX_+WO4Zr7TGWdjCNo_cdk+aSAmRNzpPUW_NxirnMEBCw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:14:56PM -0800, Yinghai Lu wrote:
> On Tue, Mar 5, 2013 at 11:52 AM, Robin Holt <holt@sgi.com> wrote:
> > That fixed it for me.
> >
> > Can you help me understand why sentinel is non-zero?  It looks to me
> > like 3.14 allocates 16kB plus strlen of the command line, zeros it,
> > and then proceeds to fill in fields, some differing from what is in the
> > boot_params structure.  That said, it looks like the sentinel field
> > should remain 0.  I am still trying to understand, but if this patch
> > makes it in, I am happy.
> 
> sentinel is out of setup_header.
> it is 0x1ef. setup_header is from 0x1f1.
> 
> it will be 0xff from arch/x86/boot/header.S for bzImage.
> 
>         .section ".header", "a"
>         .globl  sentinel
> sentinel:       .byte 0xff, 0xff        /* Used to detect broken loaders */
> 
> elilo first copy first page, and get 0x1f1 for setup code sector number.
> then it copies all setup code ( include setup header).
> 
> after that sysdeps_create_boot_params will copy first two pages to bp...
> CopyMem(bp, param_start, 0x2000);

Had not gotten that far in my understanding of elilo.  Now I understand.

Robin
