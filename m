Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbbAGCS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:18:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61947 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbbAGCSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:55 -0500
Date: Tue, 6 Jan 2015 18:21:28 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 percpu/for-3.20] percpu_ref: remove unnecessary
 ACCESS_ONCE() in percpu_ref_tryget_live()
Message-ID: <20150107022128.GC2433@kmo-pixel>
References: <20150106152347.GD3077@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106152347.GD3077@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:23:47AM -0500, Tejun Heo wrote:
> __ref_is_percpu() needs the implied ACCESS_ONCE() in
> lockless_dereference() on @ref->percpu_count_ptr because the value is
> tested for !__PERCPU_REF_ATOMIC, which may be set asynchronously, and
> then used as a pointer.  If the compiler generates a separate fetch
> when using it as a pointer, __PERCPU_REF_ATOMIC may be set in between
> contaminating the pointer value.
> 
> percpu_ref_tryget_live() also uses ACCESS_ONCE() to test
> __PERCPU_REF_DEAD; however, there's no reason for this.  I just copied
> ACCESS_ONCE() usage blindly from __ref_is_percpu().  All it does is
> confusing people trying to understand what's going on.
> 
> This patch removes the unnecessary ACCESS_ONCE() usage from
> percpu_ref_tryget_live() and adds a comment explaining why
> __ref_is_percpu() needs it.

lockless_dereference() is new - cool! I've been wanting that without even
realizing it.

Acked-by: Kent Overstreet <kmo@daterainc.com>
