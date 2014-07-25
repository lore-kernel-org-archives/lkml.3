Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbaGYH0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:26:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:46276 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGYH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:26:09 -0400
Date: Fri, 25 Jul 2014 09:26:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
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
Subject: Re: [PATCH v5 2/7] crypto: SHA1 multibuffer crypto hash
 infrastructure
Message-ID: <20140725072605.GU3935@laptop>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
 <1406066972.2970.804.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406066972.2970.804.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:09:32PM -0700, Tim Chen wrote:
> This patch introduces the multi-buffer crypto daemon which is responsible
> for submitting crypto jobs in a work queue to the responsible multi-buffer
> crypto algorithm.  The idea of the multi-buffer algorihtm is to put
> data streams from multiple jobs in a wide (AVX2) register and then
> take advantage of SIMD instructions to do crypto computation on several
> buffers simultaneously.
> 
> The multi-buffer crypto daemon is also responsbile for flushing the
> remaining buffers to complete the computation if no new buffers arrive
> for a while.

How is any of this SHA1 specific as the Subject says it is?
