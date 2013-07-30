Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3G3OBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:01:12 -0400
Received: from mail-gh0-f173.google.com ([209.85.160.173]:47916 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab3G3OBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:01:10 -0400
Date: Tue, 30 Jul 2013 10:01:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 3/3] raid5: only wakeup necessary threads
Message-ID: <20130730140106.GE12016@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055425.056034691@kernel.org>
 <20130730124655.GB2599@htj.dyndns.org>
 <20130730132414.GB30352@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730132414.GB30352@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Shaohua.

On Tue, Jul 30, 2013 at 09:24:14PM +0800, Shaohua Li wrote:
> In the raid5 case, it's very hard to keep the order the bios passed in, because
> we need read some disks, calculate parity, and write some disks, the timing
> could break any kind of order. Besides the workqueue handles 8 stripes one
> time, so I suppose this keeps some order if there is.

Of course, it can't be absolute but still keeping the relative
ordering and temporal locality (ie. issue IOs in order once the XOR
calculation of the whole source bio is done rather than issuing as
each block completes calculation) would help quite a bit.

Thanks.

-- 
tejun
