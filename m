Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaEITlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:41:44 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:42236 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbaEITln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:41:43 -0400
Date: Fri, 9 May 2014 15:41:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH percpu/for-3.16 2/2] percpu-refcount: implement
 percpu_ref_tryget()
Message-ID: <20140509194140.GC4486@htj.dyndns.org>
References: <20140507155511.GB26540@htj.dyndns.org>
 <20140507155647.GC26540@htj.dyndns.org>
 <20140507155810.GD26540@htj.dyndns.org>
 <20140509194020.GB2276@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509194020.GB2276@kmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:40:21PM -0700, Kent Overstreet wrote:
> On Wed, May 07, 2014 at 11:58:10AM -0400, Tejun Heo wrote:
> > Implement percpu_ref_tryget() which fails if the refcnt already
> > reached zero.  Note that this is different from the recently renamed
> > percpu_ref_tryget_live() which fails if the refcnt has been killed and
> > is draining the remaining references.  percpu_ref_tryget() succeeds on
> > a killed refcnt as long as its current refcnt is above zero.
> 
> I'd still kind of prefer tryget() to be labelled "deprecated, don't use outside
> the cgroup code" or somesuch, but it's not a huge deal :)

Hmmm... why would it be deprecated?  These are just two different
operations.

Thanks.

-- 
tejun
