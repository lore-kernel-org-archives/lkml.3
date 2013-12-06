Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab3LFRzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:55:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59201 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab3LFRz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:55:28 -0500
Message-ID: <52A20F80.9000601@zytor.com>
Date: Fri, 06 Dec 2013 09:55:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH v2 3/3] X86, mpx: Intel MPX xstate feature definition
References: <1386375658-2191-1-git-send-email-qiaowei.ren@intel.com> <1386375658-2191-3-git-send-email-qiaowei.ren@intel.com> <52A20AD6.8080706@redhat.com>
In-Reply-To: <52A20AD6.8080706@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 09:35 AM, Paolo Bonzini wrote:
> 
> Sorry for the back-and-forth, but I think this and the removal of
> XSTATE_FLEXIBLE (perhaps XSTATE_LAZY?) makes your v2 worse than v1.
> 
> Since Peter already said the same, please undo these changes.
> 
> Also, how is XSTATE_EAGER used?  Should MPX be disabled when xsaveopt is
> disabled on the kernel command line?  (Liu, how would this affect the
> KVM patches, too?)
> 

There are two options: we could disable MPX etc. or we could force eager
saving (using xsave) even if xsaveopt is disabled.  It is a hard call to
make, but I guess I'm leaning towards the latter; we could add an
"lazyxsave" option to explicitly disable all eager features if there is
use for that.

	-hpa


