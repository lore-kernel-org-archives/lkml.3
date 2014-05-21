Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaEUNUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:20:41 -0400
Received: from kanga.kvack.org ([205.233.56.17]:42061 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaEUNUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:20:40 -0400
Date: Wed, 21 May 2014 09:20:38 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-aio@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hanging aio process
Message-ID: <20140521132038.GL2915@kvack.org>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett> <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com> <alpine.LFD.2.11.1405201945280.1631@denkbrett> <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com> <alpine.LFD.2.11.1405210954110.1579@denkbrett> <alpine.LFD.2.11.1405211042350.1579@denkbrett>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1405211042350.1579@denkbrett>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:48:55AM +0200, Sebastian Ott wrote:
> > 
> > I already did that and it didn't change, always 1 + (1UL << 31) in all
> > cases, before and after percpu_ref_kill(&ctx->reqs). I'm not really
> > familiar with this percpu_ref stuff but it looks like the initial
> > reference is dropped asynchronous.
> 
> 
> cat /sys/kernel/debug/tracing/trace

Your trace still isn't monitoring aio_complete().  You need to check if 
aio_complete() is getting called in order to determine if the bug is in 
the core aio code or not.

		-ben
-- 
"Thought is the essence of where you are now."
