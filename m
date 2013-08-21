Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3HUXm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:42:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:7314 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab3HUXmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:42:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="349875276"
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Xen-devel@lists.xen.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with existing use
References: <5214C524.1050900@citrix.com>
	<dc8456d1-a89a-44c0-bebb-83cb0526230e@email.android.com>
	<20130821141926.GT18673@moon>
	<CA+55aFyk6s1t92HJ5rxKZQk6dTfszmhdXz+S=MqUmM-CbMo+DQ@mail.gmail.com>
	<20130821230557.GD18673@moon>
Date: Wed, 21 Aug 2013 16:42:53 -0700
In-Reply-To: <20130821230557.GD18673@moon> (Cyrill Gorcunov's message of "Thu,
	22 Aug 2013 03:05:57 +0400")
Message-ID: <87wqnehapu.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:
>
> Hi all, I worked on patch which would not touch PSE bit for dirty page
> tracking and the result is not that good:
>
>  - 2level pages now always page dirty if page is swapped in and out, because
>    there is no space left in PTE (other than PSE bit)

Maybe just don't support soft dirty for 2 level page tables?

2 level page tables should be really on the way out anyways, as they
have severe limits and do not support NX. With 3 levels there is enough
space.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
