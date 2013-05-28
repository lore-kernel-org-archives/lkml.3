Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3E1SmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:42:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3E1SmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:42:11 -0400
X-Authority-Analysis: v=2.0 cv=IZAFqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jAay3zO7q-IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yqpGnbv0ZiAA:10 a=cAB-j3MG3DBXrZ6-sWAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130528183841.535484906@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 28 May 2013 14:38:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] rcu/ftrace: Add rcu_dereference_raw_notrace() and friends
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

As you suggesed using the name "*_notrace", I updated my patch. There's
two patches now.

The first patch adds two new APIs to the RCU system.
 rcu_dereference_raw_notrace()
 hlist_for_each_entry_rcu_notrace()

I needed the second one as the function tracer uses that too and it
calls rcu_dereference_raw().

Is this acceptable for you? If so can you give me your acked-by, so that
I can push this up to Linus. Otherwise, the system locks up when doing
function tracing with too much RCU debug running.

Thanks,

-- Steve


