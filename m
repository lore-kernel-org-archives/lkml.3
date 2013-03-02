Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3CBDsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:48:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22209 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3CBDst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:48:49 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CWa6cfpS1d4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=67B3l9YICOsA:10 a=cJEugT42xeWdX7EgN7sA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362196127.1231.76.camel@gandalf.local.home>
Subject: Re: [PATCH 3/4] tracing: Annotate event field-defining functions
 with __init
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 01 Mar 2013 22:48:47 -0500
In-Reply-To: <5125877D.5000201@huawei.com>
References: <51258723.2040301@huawei.com> <5125877D.5000201@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 10:33 +0800, Li Zefan wrote:
> Those functions are called either during kernel boot or module init.
> 
> Before:
> 
> $ dmesg | grep 'Freeing unused kernel memory'
> Freeing unused kernel memory: 1208k freed
> Freeing unused kernel memory: 1360k freed
> Freeing unused kernel memory: 1960k freed
> 
> After:
> 
> $ dmesg | grep 'Freeing unused kernel memory'
> Freeing unused kernel memory: 1236k freed
> Freeing unused kernel memory: 1388k freed
> Freeing unused kernel memory: 1960k freed

Also nice :-)

Here's my numbers (again with lots of debug enabled):

old:
[    0.027087] Freeing SMP alternatives: 12k freed
[    6.835298] Freeing initrd memory: 8004k freed
[   18.820837] Freeing unused kernel memory: 1092k freed
[   18.838487] Freeing unused kernel memory: 1456k freed
[   18.850665] Freeing unused kernel memory: 1544k freed

new:
[    0.025087] Freeing SMP alternatives: 12k freed
[    6.775349] Freeing initrd memory: 8004k freed
[   18.753519] Freeing unused kernel memory: 1144k freed
[   18.771447] Freeing unused kernel memory: 1508k freed
[   18.783637] Freeing unused kernel memory: 1544k freed

Lets hope these pass all my tests.

-- Steve



