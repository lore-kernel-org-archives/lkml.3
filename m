Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3EUUlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:41:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3EUUlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:41:24 -0400
Date: Tue, 21 May 2013 13:41:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ric Mason <ric.masonn@gmail.com>, Simon Jeons <simon.jeons@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/2] Make the batch size of the percpu_counter
 configurable
Message-Id: <20130521134122.4d8ea920c0f851fc2d97abc9@linux-foundation.org>
In-Reply-To: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
References: <8584b08e57e97ecc4769859b751ad459d038a730.1367574872.git.tim.c.chen@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 May 2013 03:10:52 -0700 Tim Chen <tim.c.chen@linux.intel.com> wrote:

> Currently, there is a single, global, variable (percpu_counter_batch) that
> controls the batch sizes for every 'struct percpu_counter' on the system.
> 
> However, there are some applications, e.g. memory accounting where it is
> more appropriate to scale the batch size according to the memory size.
> This patch adds the infrastructure to be able to change the batch sizes
> for each individual instance of 'struct percpu_counter'.
> 

This patch seems to add rather a lot of unnecessary code.

- The increase in the size of percu_counter is regrettable.

- The change to percpu_counter_startup() is unneeded - no
  percpu_counters should exist at this time.  (We may have screwed this
  up - percpu_counter_startup() shuold probably be explicitly called
  from start_kernel()).

- Once the percpu_counter_startup() change is removed, all that code
  which got moved out of CONFIG_HOTPLUG_CPU can be put back.

And probably other stuff.


If you want to use a larger batch size for vm_committed_as, why not
just use the existing __percpu_counter_add(..., batch)?  Easy.

