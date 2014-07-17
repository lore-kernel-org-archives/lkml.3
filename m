Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbaGQP03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:26:29 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:59028
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934214AbaGQP00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:26:26 -0400
Date: Thu, 17 Jul 2014 10:26:24 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <53C7E5C8.9070400@gmail.com>
Message-ID: <alpine.DEB.2.11.1407171023150.28248@gentwo.org>
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org> <53C7E234.3020503@gmail.com> <alpine.DEB.2.11.1407170953070.28248@gentwo.org>
 <53C7E5C8.9070400@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Pranith Kumar wrote:

> I can mention that IPI is preferable. What is that you don't want mentioned? atomic_t?

Definitely not as an example. atomic_t in per cpu areas is self
contradicting. The per cpu area is exclusively for that processor whereas
an atomic_t is supposed to be accessed from multiple processors.

> > Remote percpu updates are extremely rare events. If the cpu is idle/asleep
> > then usually no updates are needed because no activity is occurring on
> > that cpu.
> >
>
> Yes, -usually- that is the case. But we are talking about the extreme rare event
> where we need to update some remote CPU`s per-cpu data without waking it up from
> sleep/idle. How do you suggest we handle this? I don't think suggesting not to
> use per-cpu areas because of this is a good idea, since we lose a lot of
> performance in the most common cases.

If you modify a percpu area then that is usually done because that cpu
needs to take some action. An IPI is fine.

Otherwise yes I would suggest not use a percpu area but a separate data
structure for synchronization.
