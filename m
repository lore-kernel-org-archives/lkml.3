Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaFMSY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:24:29 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58625 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaFMSY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:24:28 -0400
Date: Fri, 13 Jun 2014 14:24:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 02/12] percpu: introduce arch_raw_cpu_ptr()
Message-ID: <20140613182417.GA3723@htj.dyndns.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
 <1402590209-31610-3-git-send-email-tj@kernel.org>
 <alpine.DEB.2.10.1406131209540.1717@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406131209540.1717@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:10:36PM -0500, Christoph Lameter wrote:
> On Thu, 12 Jun 2014, Tejun Heo wrote:
> 
> > Currently, archs can override raw_cpu_ptr() directly; however, we
> > wanna build a layer of indirection in the generic part of percpu so
> > that we can implement generic features there without affecting archs.
> 
> Not sure why one would do this. We already have this_cpu_ptr() (arch
> independant) and the lower level raw_cpu_ptr() which can be modified by
> the arch code.

So that there's separate between generic part of definition and
arch-specific part.  This allows the generic portion of definition to
be handled in the generic code.  e.g. arch no longer has to worry
about verifying arguments or having a data dependency barrier.  It
just has to worry about the core implementation.  The generic layer
can handle the boilerplates.

Thanks.

-- 
tejun
