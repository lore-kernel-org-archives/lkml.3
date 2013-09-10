Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3IJH4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:56:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3IJH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:56:50 -0400
Date: Tue, 10 Sep 2013 09:56:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: kernel deadlock
Message-ID: <20130910075635.GH26785@twins.programming.kicks-ass.net>
References: <521F6D06.1040107@keymile.com>
 <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net>
 <521FDD12.7050000@linaro.org>
 <52212511.9050206@keymile.com>
 <5221264F.4070402@linaro.org>
 <5225F8EF.3040701@keymile.com>
 <52261BBB.60904@linaro.org>
 <5226EB35.6080604@keymile.com>
 <522E2FBB.4070406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522E2FBB.4070406@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:29:47PM -0700, John Stultz wrote:
> Ingo: This makes me think we really should have some lockdep smarts
> added to seqlock/seqcount structures. Is there something already
> discovered thats preventing this, or has this just not yet been tried?

The only reason this hasn't been done in the past is because of the VDSO
I believe. We use a seqcount_t from userspace.

We either have to open-code the VDSO version or create a variant for
that specific single use case.
