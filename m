Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3FMD4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:56:42 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44206 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab3FMD4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:56:41 -0400
Date: Wed, 12 Jun 2013 20:56:36 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH percpu/for-3.11 2/2] percpu-refcount: implement
 percpu_ref_cancel_init()
Message-ID: <20130613035636.GF10979@localhost>
References: <20130613035201.GD9451@mtj.dyndns.org>
 <20130613035235.GE9451@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613035235.GE9451@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 08:52:35PM -0700, Tejun Heo wrote:
> Normally, percpu_ref_init() initializes and percpu_ref_kill*()
> initiates destruction which completes asynchronously.  The
> asynchronous destruction can be problematic in init failure path where
> the caller wants to destroy half-constructed object - distinguishing
> half-constructed objects from the usual release method can be painful
> for complex objects.
> 
> This patch implements percpu_ref_cancel_init() which synchronously
> destroys the percpu_ref without invoking release.  To avoid
> unintentional misuses, the function requires the ref to have finished
> percpu_ref_init() but never used and triggers WARN otherwise.

That's a good idea, I should've implemented that for aio.

I probably would've just gone with percpu_ref_free() (if caller knows
it's safe, they can do whatever they want) but I suppose I can live with
percpu_ref_cancel_init().

Acked-by: Kent Overstreet <koverstreet@google.com>
