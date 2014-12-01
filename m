Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbaLAXZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:25:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623AbaLAXY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:24:59 -0500
Date: Tue, 2 Dec 2014 00:24:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] exit: pidns: fix/update the comments in
	zap_pid_ns_processes()
Message-ID: <20141201232442.GA10487@redhat.com>
References: <20141126235416.GA32688@redhat.com> <20141126235437.GA386@redhat.com> <20141201143913.8780d386f9ad3ef87aeadd17@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201143913.8780d386f9ad3ef87aeadd17@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01, Andrew Morton wrote:
>
> On Thu, 27 Nov 2014 00:54:37 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > The comments in zap_pid_ns_processes() are not clear, we need to
> > explain how this code actually works.
>
> Could we please get some documentation for PIDNS_HASH_ADDING?  What it
> does, what is the protocol for handling it, etc?  I was trying to
> review your [1/2] but this little mystery has me somewhat stumped.

OK, I'll send another simple doc patch.

But in short it is simple. "nr_hashed & PIDNS_HASH_ADDING" just means
that this pid_ns is alive, and alloc_pid() can succeed. We need this to
ensure that a new child can't be injected after zap_pid_ns_processes()
has already killed all tasks in its pid_ns.

Oleg.

