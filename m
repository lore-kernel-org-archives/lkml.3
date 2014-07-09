Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaGINpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:45:41 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47413 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbaGINph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:45:37 -0400
Message-ID: <53BD477F.7040902@gmail.com>
Date: Wed, 09 Jul 2014 07:45:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf kvm: Move arch specific code into arch/
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com> <1404397747-20939-3-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1404397747-20939-3-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/14, 8:29 AM, Alexander Yarygin wrote:
> Parts of a 'perf kvm stat' code make sense only for x86.
> Let's move this code into the arch/x86/kvm-stat.c file and add
> util/kvm-stat.h for generic structure definitions.
>
> Add a global array 'kvm_reg_events_ops' for accessing the
> arch-specific 'kvm_events_ops' from generic code.
>
> Since the several global arrays (i.e. 'kvm_events_tp') have been moved
> to arch/*, we can not know their sizes and use them directly in
> builtin-kvm.c. This patch fixes that problem by adding trimming
> NULL element to each array and changing the behavior of their handlers
> in generic code.
>
> Signed-off-by: Alexander Yarygin<yarygin@linux.vnet.ibm.com>
> Reviewed-by: Cornelia Huck<cornelia.huck@de.ibm.com>

Reviewed-by David Ahern <dsahern@gmail.com>

Compiled and Tested on x86

