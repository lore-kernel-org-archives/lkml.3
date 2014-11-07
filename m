Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaKGKPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:15:51 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39019 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKGKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:15:49 -0500
Date: Fri, 7 Nov 2014 02:15:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vivek Goyal <vgoyal@redhat.com>
cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        jbaron@akamai.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v8] kernel, add panic_on_warn
In-Reply-To: <20141106220731.GA13590@redhat.com>
Message-ID: <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com> <545B733C.6080903@redhat.com> <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com>
 <20141106220731.GA13590@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Vivek Goyal wrote:

> On Thu, Nov 06, 2014 at 01:57:36PM -0800, David Rientjes wrote:
> 
> [..]
> > You see that doing
> > 
> > 	if (panic_on_warn) {
> > 		panic_on_warn = 0;
> > 		panic(...);
> > 	}
> > 
> > is racy, I hope.  If two threads WARN() at the same time, then there's 
> > nothing preventing a double panic() because WARN() itself is not 
> > serialized against anything.  So both the current comment and your 
> > suggested revision comment are bogus.
> 
> panic() is serialized on panic_lock. So I guess it is fine to hit WARN()
> on multiple cpus. Do you see an issue there?
> 

No issue at all, what's completely mysterious is the panic_on_warn = 0 and 
the completely bogus comment that says "prevent further WARN()s from 
panicking the system" when that's racy.  There's no need to clear 
panic_on_warn at all.
