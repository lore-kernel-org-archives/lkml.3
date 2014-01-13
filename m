Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaAMVVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:21:53 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55689 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaAMVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:21:52 -0500
Message-ID: <52D458E8.70203@linux.vnet.ibm.com>
Date: Mon, 13 Jan 2014 13:21:44 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf: clarify comment regarding event merging
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com> <1389311492-5059-3-git-send-email-cody@linux.vnet.ibm.com> <20140110093635.GI31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140110093635.GI31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011321-9332-0000-0000-000002BF6805
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 01:36 AM, Peter Zijlstra wrote:
> On Thu, Jan 09, 2014 at 03:51:31PM -0800, Cody P Schafer wrote:
>> There are actually 2 things about software events that allow us to
>> merge them: they never fail to schedule _and_ they have transaction
>> handlers we can (and do, when they are added to !sw groups) ignore. Note
>> both of these in the comment on adding sw events to !sw groups.
>
> The latter is a direct consequence of the former. Since they can always
> be scheduled, they don't need any schedulability testing, and therefore
> the transaction stuff is useless.

Right. I guess what I was getting at were the 2 types of "schedulability":
	1. individual event schedulability (ie: "did add() return an error?")
	2. txn schedulability (ie: "did commit_txn() return an error?")

I'm in the process of adding a pmu which guarantees #1, but not #2 (it 
essentially provides access to some always-running counters which can be 
atomically copied in groups). As a result, I'm teasing apart some of the 
special casing done for sw events.

This will probably make a bit more sense with some better terminology on 
my part and some actual code. I'll update and resend later.


