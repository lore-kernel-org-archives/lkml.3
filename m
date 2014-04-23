Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaDWT1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:27:15 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:48705 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:27:11 -0400
Date: Wed, 23 Apr 2014 15:27:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Message-ID: <20140423192707.GD4163@mtj.dyndns.org>
References: <20140414193214.GC16835@htj.dyndns.org>
 <20140415135359.GA13033@redhat.com>
 <20140415140650.GI1863@htj.dyndns.org>
 <20140415141826.GB17018@redhat.com>
 <20140423170141.GJ4781@htj.dyndns.org>
 <20140423171720.GF24651@redhat.com>
 <20140423185231.GA4163@mtj.dyndns.org>
 <20140423185835.GD22755@redhat.com>
 <20140423190043.GB4163@mtj.dyndns.org>
 <20140423192108.GF22755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423192108.GF22755@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 23, 2014 at 03:21:09PM -0400, Vivek Goyal wrote:
> In general this idea makes sense. Exporting both request and bio will
> solve the problem of io accounting. Also that should allow us to
> get rid of blkio.io_merged.

Yeah, that'd make more sense, I think.  IO submitted vs. actually
executed after merging.  Pretty clear definition.

> What about sync/async differentiation? Throttling layer seems to flag a request sync
> only if bio->bi_rw flag has REQ_SYNC set. While CFQ seems to consider
> request sync if bio is either read or bio->bi_rw has REQ_SYNC flag set.

Heh, I think we'd need to unify those no matter what.  The subtle
difference is extremely confusing.

> So we need to make this definition uniform. Or I am wondering do we
> really need to export sync/async data. (Again put in by google folks).
> How useful this info really is. 

Hmmmm... yeah, maybe that'd be the best way to go about it.

Thanks.

-- 
tejun
