Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3CBDhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:37:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3CBDhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:37:36 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=iEPR1DyhxEQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jyYJBpVl-1wA:10 a=3UUwGg88sV5-XWJk3ugA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362195455.1231.74.camel@gandalf.local.home>
Subject: Re: [PATCH 2/4] tracing: Add a helper function for event print
 functions
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 22:37:35 -0500
In-Reply-To: <51258746.2060304@huawei.com>
References: <51258723.2040301@huawei.com> <51258746.2060304@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 10:32 +0800, Li Zefan wrote:
> Move duplicate code in event print functions to a helper function.
> 
> This shrinks the size of the kernel by ~13K.
> 
>    text    data     bss     dec     hex filename
> 6596137 1743966 10138672        18478775        119f6b7 vmlinux.o.old
> 6583002 1743849 10138672        18465523        119c2f3 vmlinux.o.new

Nice! I just tried it out and got:

   text    data     bss     dec     hex filename
7747813 1673816 1503232 10924861         a6b33d vmlinux.old
7715443 1673560 1499136 10888139         a623cb vmlinux.new

Of course I have a lot of debugging enabled at the moment, which
probably exaggerates these numbers a bit. But still, 36K in savings is
nice for even a debug kernel :-)

I'll start beating on this patch for a bit, and will most likely add it
to my v3.10 queue.

Thanks!

-- Steve


