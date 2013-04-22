Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3DVWfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 18:35:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3DVWfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:35:43 -0400
Date: Mon, 22 Apr 2013 15:35:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <kosaki.motohiro@gmail.com>, <mingo@kernel.org>, <hpa@zytor.com>,
        <srivatsa.bhat@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v2] numa, cpu hotplug: Change links of CPU and
 node when changing node number by onlining CPU
Message-Id: <20130422153541.04ba682f13910cfede0d2ff7@linux-foundation.org>
In-Reply-To: <5170D4CB.20900@jp.fujitsu.com>
References: <5170D4CB.20900@jp.fujitsu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Apr 2013 14:23:23 +0900 Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:

> When booting x86 system contains memoryless node, node numbers of CPUs
> on memoryless node were changed to nearest online node number by
> init_cpu_to_node() because the node is not online.
> 
> ...
>
> If we hot add memory to memoryless node and offine/online all CPUs on
> the node, node numbers of these CPUs are changed to correct node numbers
> by srat_detect_node() because the node become online.

OK, here's a dumb question.

At boot time the CPUs are assigned to the "nearest online node" rather
than to their real memoryless node.  The patch arranges for those CPUs
to still be assigned to the "nearest online node" _after_ some memory
is hot-added to their real node.  Correct?

Would it not be better to fix this by assigning those CPUs to their real,
memoryless node right at the initial boot?  Or is there something in
the kernel which makes cpus-on-a-memoryless-node not work correctly?

