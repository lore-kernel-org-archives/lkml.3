Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3HUOXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:23:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40126 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab3HUOXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:23:47 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130821141223.GS18673@moon>
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with existing use
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 21 Aug 2013 16:22:44 +0200
To: Cyrill Gorcunov <gorcunov@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Message-ID: <035dc4d7-10e0-4e15-bdb4-3e353b271fe4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good question...

Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>On Wed, Aug 21, 2013 at 02:48:20PM +0100, David Vrabel wrote:
>> All,
>> 
>> 179ef71c (mm: save soft-dirty bits on swapped pages) introduces a new
>> PTE bit on x86 _PTE_SWP_SOFT_DIRTY which has the same value as
>_PTE_PSE
>> and _PTE_PAT.
>> 
>> With a Xen PV guest, the use of the _PTE_PAT will result in the page
>> having unexpected cachability which will introduce a range of subtle
>> performance and correctness issues.  Xen programs the entry 4 in the
>PAT
>> table with WC so a page that was previously WB will end up as WC.
>> 
>
>David, could you please explain, Xen keeps and analyze _PTE_PAT bit
>for ptes which are not present?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
