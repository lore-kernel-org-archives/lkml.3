Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaBGTHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:07:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:49569 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaBGTHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:07:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,802,1384329600"; 
   d="scan'208";a="477759048"
Message-ID: <52F52EDA.4080007@linux.intel.com>
Date: Fri, 07 Feb 2014 11:07:06 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com> <52E5EFAF.3060609@linux.intel.com> <CAFLxGvxJ0A6hZ52RWffkg_zXXScyPn10P4HcKvdAXfE43h32Eg@mail.gmail.com> <52E601DA.7010605@zytor.com> <20140130220708.GP9951@redhat.com> <CAGXu5jKp0j71ucE7uOWRa+gQM1Wzp=_KdByJK4XnACTwiCW4ow@mail.gmail.com> <20140207144914.GA5949@redhat.com>
In-Reply-To: <20140207144914.GA5949@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:49 AM, Vivek Goyal wrote:
> 
> As a workaround, Dave is currently using "nokaslr" command line parameter
> for second kernel. He is still facing issues where makedumpfile segment
> faults. He is looking into it further.
> 

Now, let's state this: kaslr for kdump is almost certainly useless (the
amount of reserved memory is not enough to provide any meaningful
randomization, so any randomization needs to happen during the memory
reservation phase.)  So disabling kaslr in the kdump kernel is entirely
appropriate.

	-hpa


