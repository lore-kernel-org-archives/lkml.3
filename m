Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3HGUpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:45:33 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:59034 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab3HGUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:45:31 -0400
Date: Wed, 7 Aug 2013 16:45:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2] mm: make lru_add_drain_all() selective
Message-ID: <20130807204527.GB28039@mtj.dyndns.org>
References: <201308071458.r77EwuJV013106@farm-0012.internal.tilera.com>
 <201308071551.r77FpWTf022475@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308071551.r77FpWTf022475@farm-0012.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 04:22:39PM -0400, Chris Metcalf wrote:
> This change makes lru_add_drain_all() only selectively interrupt
> the cpus that have per-cpu free pages that can be drained.
> 
> This is important in nohz mode where calling mlockall(), for
> example, otherwise will interrupt every core unnecessarily.

Can you please split off workqueue part into a separate patch with
proper description?  I don't mind the change eventually going through
-mm but it's nasty to bury workqueue API update with another change
without explanation or justification.

Thanks.

-- 
tejun
