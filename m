Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3DLKul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:50:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49743 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3DLKuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:50:40 -0400
Message-ID: <1365763837.17140.52.camel@laptop>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Peter Zijlstra <peterz@infradead.org>
To: Olivier Langlois <olivier@trillion01.com>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 12:50:37 +0200
In-Reply-To: <1365608911.707.65.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:48 -0400, Olivier Langlois wrote:
> 
> You have valid concerns and I will attempt to clarify the changes I
> propose. Before I do, realise that as a first time patcher, I
> sincerely
> attempted to minimize the changes required to fix the posix cputimers.

Right, I suspect some of that is what made me go yuck! when reading the
patch. I feel some interfaces could be avoided if we refactor a bit
more -- and given the complexity of the code its well worth doing.

> The real source of the problem is that the process clock is distinct
> from its cputimer. It is not explained why it is done like that in the
> code but I understand that the benefit is that you can fetch the
> cputimer value and avoiding the cost to traverse the list of tasks
> member of the group. The price to pay however it is that it is painful
> to make sure that the clock and its corresponding cputimer remain in
> sync as they advance. With that in mind, I did all I can to minimize
> thread group task list traversal when possible and do it only when
> mandatory which is when you set a timer expiration time.

Right, I hope my earlier email explained why it is so expensive and
thus why they're separated.

I'll try and dig through the rest of your email later.. sorry for being
a tad slow etc.

