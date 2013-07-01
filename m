Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3GAVqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:46:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:57351 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3GAVqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:46:00 -0400
Date: Mon, 1 Jul 2013 23:46:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Hogan <james.hogan@imgtec.com>
cc: linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] metag: smp: don't spin waiting for CPU to start
In-Reply-To: <1372694659-30176-4-git-send-email-james.hogan@imgtec.com>
Message-ID: <alpine.DEB.2.02.1307012342500.4013@ionos.tec.linutronix.de>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-4-git-send-email-james.hogan@imgtec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, James Hogan wrote:
> Use a completion to block until a secondary CPU has started up, like ARM
> do, instead of a loop of udelays.
> 
> On Meta, SMP is really SMT, with each "CPU" being a different hardware
> thread on the same Meta processor core, so as well as being more
> efficient and latency friendly, using a completion prevents the bogomips
> of the secondary CPU from being drastically skewed every time by the
> execution of the tight in-cache udelay loop on the other CPU.

The least of our worries is the correctness of bogomips. But if that
patch makes bogomips less bogus while fixing a real issue, please add
my
 
Acked-by: Thomas Gleixner <tglx@linutronix.de>
