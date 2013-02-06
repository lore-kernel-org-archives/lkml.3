Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3BFQqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:46:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11717 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab3BFQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:46:45 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_Bp3_fu7e2UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=wIfm1DkAj9kA:10 a=jQ6o5W8w3HXbc1GdhO8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360169204.2621.47.camel@gandalf.local.home>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 06 Feb 2013 11:46:44 -0500
In-Reply-To: <20130206163917.GA15403@gmail.com>
References: <5111AD8D.1080005@candelatech.com>
	 <20130206015430.GA9161@home.goodmis.org> <5111BF51.5010607@candelatech.com>
	 <1360119124.2621.37.camel@gandalf.local.home>
	 <5111CE60.4080403@candelatech.com>
	 <1360125419.2621.39.camel@gandalf.local.home>
	 <5111F6F6.7010402@candelatech.com>
	 <1360156888.2621.42.camel@gandalf.local.home>
	 <51127D15.7080503@candelatech.com>
	 <1360166840.2621.45.camel@gandalf.local.home>
	 <20130206163917.GA15403@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-06 at 17:39 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> Wondering whether we could improve lockdep to detect 'excessive' 
> lock nesting and treat it as a bug - the 'ran out of lockdep 
> entries' assert might be too detached and it might even trigger 
> in innocent, low lesting count contexts.

Probably adding a call to lockdep_printk_held_locks(current) when it
triggers, would be a good idea.

-- Steve


