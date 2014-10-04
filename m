Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaJDOuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 10:50:12 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:61429 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaJDOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 10:50:10 -0400
Date: Sat, 4 Oct 2014 09:50:04 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slowdown due to threads bouncing between HT cores
Message-ID: <20141004095004.3b84095f@as>
In-Reply-To: <20141003194428.GA27084@sesse.net>
References: <20141003194428.GA27084@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2014 21:44:29 +0200
"Steinar H. Gunderson" <sgunderson@bigfoot.com> wrote:

> Hi,
> 
> I did a chess benchmark of my new machine (2x E5-2650v3, so 20x2.3GHz
> Haswell-EP), and it performed a bit worse than comparable Windows setups.
> It looks like the scheduler somehow doesn't perform as well with
> hyperthreading; HT is on in the BIOS, but I'm only using 20 threads
> (chess scales sublinearly, so using all 40 usually isn't a good idea),
> so really, the threads should just get one core each and that's it.
> It looks like they are bouncing between cores, reducing overall performance
> by ~20% for some reason. (The machine is otherwise generally idle.)
> 

Try playing with /proc/sys/kernel/sched_migration_cost_ns. This sets
the number of nanoseconds the kernel will wait before considering
moving a thread to another CPU. I have mine set to 50000000.
