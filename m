Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab3HUOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:19:30 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38205 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3HUOT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:19:29 -0400
Date: Wed, 21 Aug 2013 18:19:26 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130821141926.GT18673@moon>
References: <5214C524.1050900@citrix.com>
 <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 04:11:25PM +0200, H. Peter Anvin wrote:
>
> Eep.  This should be reverted, indeed.  This isn't a manifest bug on !Xen but we
> have gotten requests for WT support which would mean adding in the PAT but again.

Please no, letme fix it. That's what I'm having in mind: don't use pse bit in swap
entry but always mark page read from swap as dirty one (it's better than having
no tracker at all and  will be the case on old machines with 32bit ptes only).
