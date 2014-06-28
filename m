Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaF1MLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:11:05 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62009 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaF1MLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:11:03 -0400
Date: Sat, 28 Jun 2014 08:10:59 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org, kmo@daterainc.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET percpu/for-3.17] percpu: implement percpu_ref_reinit()
Message-ID: <20140628121059.GC10829@htj.dyndns.org>
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403053685-28240-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 09:07:59PM -0400, Tejun Heo wrote:
> Hello,
> 
> Currently, percpu_ref destruction - freeing the percpu counter -
> happens when the percpu_ref is released.  This while a bit more
> convenient restricts how percpu_ref can be used.  It can't be
> initialized with static percpu area and it can't be reinitialized
> without going through percpu allocation.
> 
> There are use cases which can take advantage of cycling percpu_ref
> through init/release multiple times.  This patchset separates out
> percpu_ref destruction into percpu_exit() which should be invoked
> explicitly and introduces percpu_ref_reinit() which can be used to
> recycle a released percpu_ref.
> 
> This patchset doesn't add any users.  Patchset to use this will soon
> be posted.
> 
> This patchset contains the following six patches.
> 
>  0001-percpu-refcount-aio-use-percpu_ref_cancel_init-in-io.patch
>  0002-percpu-refcount-one-bit-is-enough-for-REF_STATUS.patch
>  0003-percpu-refcount-add-helpers-for-percpu_count-accesse.patch
>  0004-percpu-refcount-use-unsigned-long-for-pcpu_count-poi.patch
>  0005-percpu-refcount-require-percpu_ref-to-be-exited-expl.patch
>  0006-percpu-refcount-implement-percpu_ref_reinit-and-perc.patch

Applied to percpu/for-3.17.

Thanks.

-- 
tejun
