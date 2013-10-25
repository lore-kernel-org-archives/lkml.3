Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3JYOVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:21:01 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56721 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995Ab3JYOVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:21:00 -0400
X-Sasl-enc: JmpHISYazZUT605bUoR8UqF2fiiMgm95O6A2cWU7KekY 1382710857
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20131025125921.GA29424@linux.vnet.ibm.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi>
Cc: Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>
X-Mailer: iPhone Mail (11B511)
From: Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Date: Fri, 25 Oct 2013 16:20:54 +0200
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Technically feasible. But then we would have to parse each of the
> libraries and executables to list them. Right? I am not sure if such a
> delay is acceptable.

You could do it at 'perf list' time or even build time and cache it. And add lazy discovery to 'perf record' and friends.

> Also if a binary exists in a path thats is not covered in the default
> search, an user might believe that his binary may not have markers.
> I know the above reason is more of a user folly than a tooling issue.

Lazy discovery at 'perf record'-time from executable and DSOs should make that transparent to the user, no? I'm pretty sure it will be fast enough with content-adressed cache.

- Pekka