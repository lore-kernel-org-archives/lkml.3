Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3HUTDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:03:12 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40742 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab3HUTDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:03:10 -0400
Date: Wed, 21 Aug 2013 23:03:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Vrabel <david.vrabel@citrix.com>, Jan Beulich <JBeulich@suse.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Xen-devel@lists.xen.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130821190307.GB18673@moon>
References: <5214C524.1050900@citrix.com>
 <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
 <5214F128.1000901@citrix.com>
 <20130821172547.GY18673@moon>
 <20130821181733.GC3814@moon>
 <4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:50:26PM +0200, H. Peter Anvin wrote:
> But is there a manifest bug or not?  What is the deal with Xen?
> 

I personally don't see bug here because

 - this swapped page soft dirty bit is set for non-present entries only,
   never for present ones, just at moment we form swap pte entry

 - i don't find any code which would test for this bit directly without
   is_swap_pte call

but the use of paw bit itself is confusing, so I'm working on patch which
won't use it. Again, if someone knows where exactly access to pse bit when
pte keeps swap entry may happen (for any purpose other than dirty page
tracking) please share.
