Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab3KHPHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:07:06 -0500
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:57941 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932221Ab3KHPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:07:01 -0500
Date: Fri, 8 Nov 2013 15:06:59 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
In-Reply-To: <20131107225049.GC28130@localhost.localdomain>
Message-ID: <0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com> <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org> <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
 <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org> <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com> <20131107225049.GC28130@localhost.localdomain>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.11.08-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Frederic Weisbecker wrote:

> usermodehelper works are created via workqueues, right? And workqueues are an issue as
> well for those who want CPU isolation.

AFAICT usermodehelper can be called from a variety of contexts.

> So this looks like a more general problem than just call_usermodehelper.

Well the code explicitly sets the the affinity mask to all cpus which
creates a problem for low latency processors. It does not inherit the
affinity from any calling process.

> Last time I checked, it seemed to me that this is an unbound workqueue? If so can't we tune
> the affinity of this workqueue? If not perhaps that's something we want to solve and which
> could be useful for all the users who don't want their CPU to be disturbed.

There are various contexts from which usermodehelper can be called.
Drivers use it etc.
