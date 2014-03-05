Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaCEQuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:50:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbaCEQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:50:18 -0500
Date: Wed, 5 Mar 2014 17:49:42 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, prarit@redhat.com, mgorman@suse.de,
        peterz@infradead.org, alex.shi@intel.com, hpa@zytor.com
Subject: Re: deadlock between cpu_stopper &
 native_flush_tlb_others()->smp_call_function_many()
Message-ID: <20140305174942.3efc053f@nial.usersys.redhat.com>
In-Reply-To: <5314B190.5060906@redhat.com>
References: <20140303174356.082ec348@nial.usersys.redhat.com>
	<5314B190.5060906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2014 11:45:04 -0500
Rik van Riel <riel@redhat.com> wrote:

> On 03/03/2014 11:43 AM, Igor Mammedov wrote:
> > It looks like I hit a deadlock between smp_call_function_many() and
> > cpu_stopper threads.
> 
> > Are there any suggestions on how to fix this nicely?
> 
> This patch should fix it:
> 
> https://lkml.org/lkml/2014/2/28/194

I've just tried it and it doesn't fix issue.
