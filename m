Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaEGNlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:41:46 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:41492 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaEGNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:41:45 -0400
Date: Wed, 7 May 2014 09:41:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
Message-ID: <20140507134142.GF16702@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
 <20140505143613.GD11231@htj.dyndns.org>
 <5369DC5C.20001@cn.fujitsu.com>
 <20140507131257.GB16702@htj.dyndns.org>
 <CACvQF50kdodjDGnaxgQC2sW82rvkFVLtWQDOn90cohNkzG-oZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF50kdodjDGnaxgQC2sW82rvkFVLtWQDOn90cohNkzG-oZw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 09:38:39PM +0800, Lai Jiangshan wrote:
> On Wed, May 7, 2014 at 9:12 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hello, Lai.
> >
> > On Wed, May 07, 2014 at 03:10:20PM +0800, Lai Jiangshan wrote:
> >> 1) complete() can't be called inside attach_mutex due to the worker
> >>    shouldn't access to the pool after complete().
> >
> > Sure, complete it after releasing the lock.  Shutdown can't complete
> > before the completion gets completed, right?
> >
> >> 2) put_unbound_pool() may called from get_unbound_pool(), we need to add
> >>    an additional check and avoid the wait_for_completion() if so.
> 
> Do you accept if I remove put_unbound_pool() from get_unbound_pool()
> and use several freeing code instead?

Hah?  How much extra complexity are we talking about?  It's a single
if, no?

-- 
tejun
