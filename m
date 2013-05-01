Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363Ab3EAOJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:09:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab3EAOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:09:43 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=psjH4h9LIX0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=nkIQhPGVMj0A:10 a=xH6aMwC5sC6gPU1uvLMA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1367417381.30667.78.camel@gandalf.local.home>
Subject: Re: initcall ffh_cstate_init+0x0/0x2a returned with error code -1
 throws WARN
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: ard@telegraafnet.nl, akpm@linux-foundation.org, hpa@zytor.com,
        len.brown@intel.com, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        rjw@sisk.pl
Date: Wed, 01 May 2013 10:09:41 -0400
In-Reply-To: <20130501134814.GA5001@phenom.dumpdata.com>
References: <20130501134814.GA5001@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 09:48 -0400, Konrad Rzeszutek Wilk wrote:
> Now with the git commit f91eb62f71b31e69e405663ff8d047bc3b9f7525
> (init: scream bloody murder if interrupts are enabled too early)

Perhaps I got a little too aggressive with that patch. The warnings look
to be caused by:

@@ -702,9 +697,7 @@ int __init_or_module do_one_initcall(initcall_t fn)
                strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
                local_irq_enable();
        }
-       if (msgbuf[0]) {
-               printk("initcall %pF returned with %s\n", fn, msgbuf);
-       }
+       WARN(msgbuf[0], "initcall %pF returned with %s\n", fn, msgbuf);
 
        return ret;
 }

I'll just revert that part of the patch, and send that in.

Thanks,

-- Steve



