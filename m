Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3HUOM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:12:28 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55820 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3HUOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:12:26 -0400
Date: Wed, 21 Aug 2013 18:12:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130821141223.GS18673@moon>
References: <5214C524.1050900@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5214C524.1050900@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 02:48:20PM +0100, David Vrabel wrote:
> All,
> 
> 179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
> PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as _PTE_PSE
> and _PTE_PAT.
> 
> With a Xen PV guest, the use of the _PTE_PAT will result in the page
> having unexpected cachability which will introduce a range of subtle
> performance and correctness issues.  Xen programs the entry 4 in the PAT
> table with WC so a page that was previously WB will end up as WC.
> 

David, could you please explain, Xen keeps and analyze _PTE_PAT bit
for ptes which are not present?
