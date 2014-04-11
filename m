Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaDKSqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:46:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:22199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799AbaDKSqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,843,1389772800"; 
   d="scan'208";a="417924496"
Message-ID: <53483896.9070404@linux.intel.com>
Date: Fri, 11 Apr 2014 11:46:46 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
In-Reply-To: <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:41 AM, Linus Torvalds wrote:
> 
> Ok, so you actually do this on x86-64, and it currently works? For
> some reason I thought that 16-bit windows apps already didn't work.
> 

Some will work, because not all 16-bit software care about the upper
half of ESP getting randomly corrupted.

That is the "functionality bit" of the problem.  The other bit, of
course, is that that random corruption is the address of the kernel stack.

> Because if we have working users of this, then I don't think we can do
> the "we don't support 16-bit segments", or at least we need to make it
> runtime configurable.

I'll let you pick what the policy should be here.  I personally think
that we have to be able to draw a line somewhere sometimes (Microsoft
themselves haven't supported running 16-bit binaries for several Windows
generations now), but it is your policy, not mine.

	-hpa

