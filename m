Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab3HUSRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:17:37 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40193 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUSRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:17:36 -0400
Date: Wed, 21 Aug 2013 22:17:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen-devel@lists.xen.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130821181733.GC3814@moon>
References: <5214C524.1050900@citrix.com>
 <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
 <5214F128.1000901@citrix.com>
 <20130821172547.GY18673@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821172547.GY18673@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 09:25:47PM +0400, Cyrill Gorcunov wrote:
> > 
> > However, I do find the use of PTE bits in this way somewhat fragile.
> > What other potential corner cases might still remain that will require
> > further games with PTE bits?
> 
>   OK, so this is not a bug finally. The problem is that 2 level pte is
> quite small and 7th bit is the only one spare I can use for soft dirty
> tracking when page get swapped out. And swap engine is very depending
> on pte being non-present, so we are on a safe side.

To make it clear: I'm working on patch that won't use pse bit for dirty
page tracking, just give some time to cook it and test.
