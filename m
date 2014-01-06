Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbaAFMcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:32:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAFMcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:32:16 -0500
Date: Mon, 6 Jan 2014 12:32:07 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.2 056/185] mm: ensure get_unmapped_area() returns
 higher address than mmap_min_addr
Message-ID: <20140106123207.GB2776@hercules>
References: <lsq.1388282923.51724079@decadent.org.uk>
 <1388723203.22017.36.camel@deadeye.wl.decadent.org.uk>
 <20140106191910.7155.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106191910.7155.38390934@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 07:19:10PM +0900, Akira Takeuchi wrote:
> On Fri, 03 Jan 2014 04:26:43 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
> 
> > On Sun, 2013-12-29 at 03:08 +0100, Ben Hutchings wrote:
> > > 3.2.54-rc1 review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> > > 
> > > commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.
> > [...]
> > > [bwh: Backported to 3.2:
> > >  As we do not have vm_unmapped_area(), make arch_get_unmapped_area_topdown()
> > >  calculate the lower limit for the new area's end address and then compare
> > >  addresses with this instead of with len.  In the process, fix an off-by-one
> > >  error which could result in returning 0 if mm->mmap_base == len.]
> > 
> > I'm dropping this as I have no good way to test the backport (it's not
> > used on x86) and I didn't get any confirmation that it's right.
> 
> I'm sorry for delayed reply.
> 
> Your backport seems right.
> Additionally, I've confirmed the problem is resolved by your backport patch.

Sorry I'm also late for this review.

I guess this means the backport I made for the 3.5 kernel (and released on
3.5.7.26) is incorrect:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=commitdiff;h=745545489d25d1b9ecf2d78a8f9a31a362806d2d

Akira, could you please confirm if this is the case so that I revert it in
next release?

Cheers,
--
Luis
