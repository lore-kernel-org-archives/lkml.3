Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935506Ab3FTSic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:38:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935373Ab3FTSib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:38:31 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=EVMdXO81WbgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3fLAnx-yVNQA:10 a=BGLSRIID6CL4x3rdAMwA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371753510.18733.100.camel@gandalf.local.home>
Subject: Re: [for-next][PATCH 08/12] tracing: Add binary & filter for events
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 20 Jun 2013 14:38:30 -0400
In-Reply-To: <1371753270.18733.99.camel@gandalf.local.home>
References: <20130620033516.003166252@goodmis.org>
	 <20130620033639.723900482@goodmis.org> <51C2B8AB.8060709@broadcom.com>
	 <1371730487.18733.72.camel@gandalf.local.home>
	 <51C349BD.4030403@broadcom.com>
	 <1371753270.18733.99.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 14:34 -0400, Steven Rostedt wrote:
> On Thu, 2013-06-20 at 20:28 +0200, Arend van Spriel wrote:
> 
> > Reading the whole text with your remark in mind, I guess it does 
> > indicate there are no guarantees depending on the kernel and the list of 
> > operators are what trace-cmd supports. I overlooked/ignored the text 
> > seeing the operators.
> 
> Exactly, which means that if you over looked the text, so has others.
> The text 
> should be changed to make it more comprehensible.
> 

Would this change have helped you catch this?

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index b95e1b4..9ef1e2a 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -79,10 +79,12 @@ OPTIONS
     let you use C notation to check if an event should be processed or not.
 
 ----------------------------------------
-    ==, >=, <=, >, <, &, |, && and ||
+    ==, >=, <=, >, <, &, ~, && and ||
 ----------------------------------------
 
-    The above are usually safe to use to compare fields.
+    Note, not all of the above operators may work with all kernels.
+    The filter is passed directly to the kernel and is dependent on the
+    kernel supporting the operators.
 
 *-v*::
     This will cause all events specified after it on the command line to not

-- Steve

