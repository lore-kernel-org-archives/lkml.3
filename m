Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3JONER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:04:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566Ab3JONEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:04:15 -0400
Date: Tue, 15 Oct 2013 09:03:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hong Zhiguo <honkiko@gmail.com>, axboe@kernel.dk, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Message-ID: <20131015130346.GB31215@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131014133620.GF4722@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014133620.GF4722@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 09:36:20AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Oct 14, 2013 at 05:09:17PM +0800, Hong Zhiguo wrote:
> > From: Hong Zhiguo <zhiguohong@tencent.com>
> > 
> > Token bucket algorithm(http://en.wikipedia.org/wiki/Token_bucket)
> > is very simple and widely used for rate limiting and shaping.
> > It's well suitable for blk-throttle. And it natually works for
> > hierarchical cgroups. So I took it to replace the original time
> > _slicing_|_trimming_|_extending_ logic.
> > 
> > The advantage is simplicity, reliability and less fluctuation.
> > 
> > About 300 lines of code for time-slicing is replaced with 60 lines of
> > code for token bucket in blk-throttle.c.
> > 
> > I've tested this patch by fio with rw=randread, rw=randrw. It
> > behaves almost the same with original time-slicing implementation,
> > and with more accuracy.
> 
> Yes, this definitely is the direction we wanna take it.  I'll wait for
> Vivek to chime in but have you also tested hierarchical setup?

Hi Tejun,

I will have a look at it either today or tomorrow.

Thanks
Vivek
