Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927AbaGYQra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:47:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:47163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934870AbaGYQr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:47:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,732,1400050800"; 
   d="scan'208";a="549062248"
Subject: Re: [PATCH v5 2/7] crypto: SHA1 multibuffer crypto hash
 infrastructure
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20140725072605.GU3935@laptop>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
	 <1406066972.2970.804.camel@schen9-DESK>  <20140725072605.GU3935@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jul 2014 09:47:24 -0700
Message-ID: <1406306844.2970.870.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 09:26 +0200, Peter Zijlstra wrote:
> On Tue, Jul 22, 2014 at 03:09:32PM -0700, Tim Chen wrote:
> > This patch introduces the multi-buffer crypto daemon which is responsible
> > for submitting crypto jobs in a work queue to the responsible multi-buffer
> > crypto algorithm.  The idea of the multi-buffer algorihtm is to put
> > data streams from multiple jobs in a wide (AVX2) register and then
> > take advantage of SIMD instructions to do crypto computation on several
> > buffers simultaneously.
> > 
> > The multi-buffer crypto daemon is also responsbile for flushing the
> > remaining buffers to complete the computation if no new buffers arrive
> > for a while.
> 
> How is any of this SHA1 specific as the Subject says it is?

Yes, I should simply say multibuffer crypto hash infrastructure in the
subject line.

Tim


