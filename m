Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3CTXBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:01:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3896 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CTXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:01:33 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=IDtP91cgT7AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=-oqz9XiUJNoA:10 a=pGLkceISAAAA:8 a=t7CeM3EgAAAA:8 a=hVHj1Y6T_ge_qECo8DoA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363820491.6345.21.camel@gandalf.local.home>
Subject: Re: [PATCH] tracepoints: prevents null probe from being added
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kpark3469@gmail.com, keun-o.park@windriver.com,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 19:01:31 -0400
In-Reply-To: <20130320180113.GA24537@Krystal>
References: <1363749497-12176-1-git-send-email-kpark3469@gmail.com>
	 <1363800712.6345.17.camel@gandalf.local.home>
	 <20130320180113.GA24537@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 14:01 -0400, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Wed, 2013-03-20 at 12:18 +0900, kpark3469@gmail.com wrote:
> > > From: Sahara <keun-o.park@windriver.com>
> > > 
> > > Somehow tracepoint_entry_add/remove_probe functions allow a null probe
> > > function.
> > 
> > You actually hit this in practice, or is this just something that you
> > observe from code review?
> > 
> > >  Especially on getting a null probe in remove function, it seems
> > > to be used to remove all probe functions in the entry.
> > 
> > Hmm, that actually sounds like a feature.
> 
> Yep. It's been a long time since I wrote this code, but the removal code
> seems to use NULL probe pointer to remove all probes for a given
> tracepoint.
> 
> I'd be tempted to just validate non-NULL probe within
> tracepoint_entry_add_probe() and let other sites as is, just in case
> anyone would be using this feature.
> 
> I cannot say that I have personally used this "remove all" feature much
> though.
> 

I agree. I don't see anything wrong in leaving the null probe feature in
the removal code. But updating the add code looks like a proper change.

-- Steve


