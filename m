Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbaCKIhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:37:07 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33227 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaCKIhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:37:04 -0400
Date: Tue, 11 Mar 2014 09:36:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 01/15] sched/prio: Add a macro named NICE_TO_RLIMIT in
 prio.h.
Message-ID: <20140311083658.GB4298@osiris>
References: <cover.1394513466.git.yangds.fnst@cn.fujitsu.com>
 <f475972d21de5738cf3302ab9c95c90fd4407815.1394513466.git.yangds.fnst@cn.fujitsu.com>
 <20140311081730.GA4298@osiris>
 <531EC748.5010600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531EC748.5010600@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031108-4966-0000-0000-000008B08E99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 04:20:24PM +0800, Dongsheng Yang wrote:
> On 03/11/2014 04:17 PM, Heiko Carstens wrote:
> >On Tue, Mar 11, 2014 at 12:59:16PM +0800, Dongsheng Yang wrote:
> >>+#define NICE_TO_RLIMIT(nice)	(MAX_NICE - nice + 1)
> >Where is MAX_NICE defined? The s390 patch fails to compile.
> 
> MAX_NICE is defined in include/linux/sched/prio.h. It is applied in
> tip tree, and not in mainline yet.

Ok.

> >Also you probably want at least extra braces around the 'nice' usage to
> >avoid subtle side effects. (or make NICE_TO.. a function, whatever).
> 
> Yes, agree. Another question is that I am not sure when I need to
> use a macro and when I should use a inline function.
> 
> Could you help to give me some sugguestion?

You can ask three people and get five opinions ;)

However if your above define would have been an inline function it
wouldn't suffer from possible subtle side effects and it would have
sane type checking etc.  So usually functions should be preferred.

