Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3ARTJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:09:56 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48137 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab3ARTJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:09:53 -0500
Subject: Re: [RFC][PATCH v3] slub: Keep page and object in sync in
 slab_alloc_node()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        RT <linux-rt-users@vger.kernel.org>, Clark Williams <clark@redhat.com>,
        John Kacur <jkacur@gmail.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <0000013c4ef61783-2778b0f1-fdc1-421b-9d3e-ccd68d528115-000000@email.amazonses.com>
References: <1358446258.23211.32.camel@gandalf.local.home>
	 <1358447864.23211.34.camel@gandalf.local.home>
	 <0000013c4a69a2cf-1a19a6f6-e6a3-4f06-99a4-10fdd4b9aca2-000000@email.amazonses.com>
	 <1358458996.23211.46.camel@gandalf.local.home>
	 <0000013c4a7e7fbf-c51fd42a-2455-4fec-bb37-915035956f05-000000@email.amazonses.com>
	 <1358462763.23211.57.camel@gandalf.local.home>
	 <1358464245.23211.62.camel@gandalf.local.home>
	 <1358464837.23211.66.camel@gandalf.local.home>
	 <1358468598.23211.67.camel@gandalf.local.home>
	 <1358468924.23211.69.camel@gandalf.local.home>
	 <1358521791.7383.11.camel@gandalf.local.home>
	 <0000013c4ef61783-2778b0f1-fdc1-421b-9d3e-ccd68d528115-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jan 2013 11:09:50 -0800
Message-ID: <1358536190.11051.573.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-18 at 18:40 +0000, Christoph Lameter wrote:

> The fetching of the tid is the only critical thing here. If the tid is
> retrieved from the right cpu then the cmpxchg will fail if any changes
> occured to freelist or the page variable.
> 
> The tid can be retrieved without disabling preemption through
> this_cpu_read().

Strictly speaking, this_cpu_read() _does_ disable preemption.

Of course, on x86, this_cpu_read() uses __this_cpu_read()



