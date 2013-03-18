Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3CRSfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:35:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8296 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3CRSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:35:46 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nGpB3NLV4dgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xnoB05DE7xsA:10 a=Q4RIower6W24urrL98UA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363631744.25967.199.camel@gandalf.local.home>
Subject: Re: workqueue code needing preemption disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 18 Mar 2013 14:35:44 -0400
In-Reply-To: <20130318182631.GB3042@htj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
	 <20130318160652.GA20133@mtj.dyndns.org>
	 <1363623799.25967.172.camel@gandalf.local.home>
	 <1363624020.25967.175.camel@gandalf.local.home>
	 <1363624243.25967.178.camel@gandalf.local.home>
	 <20130318164351.GA21516@mtj.dyndns.org>
	 <1363631036.25967.193.camel@gandalf.local.home>
	 <20130318182631.GB3042@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 11:26 -0700, Tejun Heo wrote:

> > Hmm, the issue is that a "use to be" idle thread got migrated, and is
> > now being woken up by another worker. What can cause an established
> > worker to migrate without HOTPLUG being active?
> 
> It doesn't.  I think it's trying to wakeup the idle_list head.
> 

That definitely makes sense. I'll go and write up a patch.

Thanks!!!

-- Steve


