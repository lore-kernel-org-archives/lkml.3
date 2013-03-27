Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3C0Oe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:34:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3C0Oew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:34:52 -0400
Date: Wed, 27 Mar 2013 15:34:37 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core support
Message-ID: <20130327143437.GE1092@krava.brq.redhat.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <1359040242-8269-12-git-send-email-eranian@google.com>
 <20130327141425.GC1092@krava.brq.redhat.com>
 <1364394014.5053.76.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364394014.5053.76.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:20:14PM +0100, Peter Zijlstra wrote:
> On Wed, 2013-03-27 at 15:14 +0100, Jiri Olsa wrote:
> > we have correct cpumode for sample->ip, but I think it's the
> > PEBS->dla (sample->addr) where we need to guess.. right?
> 
> kernel mode very much fakes the cpumode/segment stuff for PEBS. PEBS
> assumes you're running in a linear/flat mode.
> 

say we hit the sample when kernel accesses the user data, we will endup
with IP in kernel space and DATA ptr in user space.. in theory ;-)

and that would need the cpumode guessing for DATA ptr, because
cpumode value is deduced from cs register

jirka
