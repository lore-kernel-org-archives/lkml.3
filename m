Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbaJHQyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:54:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaJHQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:54:06 -0400
Date: Wed, 8 Oct 2014 18:54:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tkhai@yandex.ru
Subject: Re: [PATCH] sched/fair: Care divide error in
 update_task_scan_period()
Message-ID: <20141008165402.GO10832@worktop.programming.kicks-ass.net>
References: <5434DCFF.1040208@jp.fujitsu.com>
 <54356970.7050805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54356970.7050805@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 12:42:24PM -0400, Rik van Riel wrote:
> On 10/08/2014 02:43 AM, Yasuaki Ishimatsu wrote:
> 
> >   The divide error is rare case because the trigger is node offline.
> >   By this patch, when both of private and shared are set to 0, diff
> >   is just set to 0, not calculating the division.
> 
> How about a simple
> 
>     if (private + shared) == 0)
>           return;
> 
> higher up in the function, to avoid adding an extra
> layer of indentation and confusion to the main part
> of the function?

At which point we'll have 3 different return semantics. Should we not
clear numa_faults_localityp[], even in this case?
