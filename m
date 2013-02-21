Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3BUTg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:36:58 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:65174 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3BUTgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:36:45 -0500
Date: Thu, 21 Feb 2013 11:36:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Marc Gauthier <marc@tensilica.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memblock: add assertion for zero allocation size
Message-ID: <20130221193639.GN3570@htj.dyndns.org>
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>
 <1361471962-25164-2-git-send-email-vgupta@synopsys.com>
 <CAE9FiQXSPHjRsCWcHpz7s1gQjNGuj5_X_YE2Ln=EA7_-Ka_cNg@mail.gmail.com>
 <51267695.8090800@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51267695.8090800@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 01:03:41AM +0530, Vineet Gupta wrote:
> Where - you mean if user passes 0, just make it 1. Nah - it's better to complain
> and get the call site fixed !
> 
> > or BUG_ON(!align) instead?
> 
> That could be done too but you would also need BUG_ON(!size) - to catch another
> API abuse.
> BUG_ON(!size) however catches both the cases.

How about "if (WARN_ON(!align)) align = __alignof__(long long);"?
Early BUG_ON()s can be painful to debug depending on setup.

Thanks.

-- 
tejun
