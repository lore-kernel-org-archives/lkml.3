Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaIKWS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:18:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:43915 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaIKWSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:18:25 -0400
Date: Fri, 12 Sep 2014 00:18:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
In-Reply-To: <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.10.1409120015030.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Qiaowei Ren wrote:

> This patch sets bound violation fields of siginfo struct in #BR
> exception handler by decoding the user instruction and constructing
> the faulting pointer.
> 
> This patch does't use the generic decoder, and implements a limited
> special-purpose decoder to decode MPX instructions, simply because the
> generic decoder is very heavyweight not just in terms of performance
> but in terms of interface -- because it has to.

And why is that an argument to add another special purpose decoder?

If a bound violation happens it is completely irrelevant whether the
decoder is heavyweight or not.

So unless you come up with a convincing argument why the generic
decoder is the wrong place, this won't happen.

Thanks,

	tglx
