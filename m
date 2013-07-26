Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899Ab3GZRMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:12:23 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44562 "HELO
	oproxy5.bluehost.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1756829Ab3GZRMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:12:21 -0400
Date: Fri, 26 Jul 2013 10:12:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCH 2/2] x86: add early quirk for reserving Intel graphics
 stolen memory v3
Message-ID: <20130726101221.016e93b5@jbarnes-desktop>
In-Reply-To: <51F2AAC5.6020808@zytor.com>
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org>
	<1374770269-3223-3-git-send-email-jbarnes@virtuousgeek.org>
	<51F2AAC5.6020808@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 09:58:45 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 07/25/2013 09:37 AM, Jesse Barnes wrote:
> > Systems with Intel graphics controllers set aside memory exclusively for
> > +	/*
> > +	 * Almost universally we can find the Graphics Base of Stolen Memory
> > +	 * at offset 0x5c in the igfx configuration space. On a few (desktop)
> > +	 * machines this is also mirrored in the bridge device at different
> > +	 * locations, or in the MCHBAR.
> > +	 */
> 
> This comment makes me nervous.  It isn't clear to me if it is saying:
> 
> - All igfx devices has the graphics base at 0x5c, a few have it in
>   other places, too (which doesn't matter, we can use 0x5c anyway), or
> - Most igfx devices have the graphics base at 0x5c, some don't, and we
>   hope and pray we're not on one of those systems because we're not
>   checking.
> 
> I assume it is the former, but it really needs to be phrased better.

I mostly copied it from the driver where we had some other ways of
finding it too.  For the PCI IDs listed, we can always use 0x5c.  I'll
fix the comment.

-- 
Jesse Barnes, Intel Open Source Technology Center
