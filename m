Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3H1Tyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:54:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50952 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3H1Tyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:54:43 -0400
Date: Wed, 28 Aug 2013 20:54:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130828195415.GP6617@n2100.arm.linux.org.uk>
References: <20130828193457.140443630@linux.com> <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 07:48:23PM +0000, Christoph Lameter wrote:
> 3. Retrieve the content of the current processors instance of a per cpu variable.
> 
> 	DEFINE_PER_CPU(int, u);

Shouldn't this be 'y' ?

> 	int x = __get_cpu_var(y)
> 
>    Converts to
> 
> 	int x = __this_cpu_read(y);
> 
> 
> 4. Retrieve the content of a percpu struct
> 
> 	DEFINE_PER_CPU(struct mystruct, y);
> 	struct mystruct x = __get_cpu_var(y);
> 
>    Converts to
> 
> 	memcpy(this_cpu_ptr(&x), y, sizeof(x));

Are you sure this one's correct?  Isn't 'y' the per-cpu variable?
Even though I don't see any in this patch, it's probably a good thing to
get the patch description correct.

I think you need Will Deacon's ack for this, but I think he's away for
a while.
