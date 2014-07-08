Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaGHPIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:08:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:26041 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753716AbaGHPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:08:04 -0400
Date: Tue, 8 Jul 2014 11:08:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] modules: Fix build error in moduleloader.h
Message-ID: <20140708110801.14fc703b@gandalf.local.home>
In-Reply-To: <87wqbo7n6u.fsf@rustcorp.com.au>
References: <20140703092121.082e0366@gandalf.local.home>
	<87wqbo7n6u.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jul 2014 09:10:09 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:
 
> Subject: modules: Fix build error in moduleloader.h
> 
> Fengguang Wu's build bot detected that if moduleloader.h is included in
> a C file (used by ftrace and kprobes to access module_alloc() when
> available), that it can fail to build if CONFIG_MODULES and
> CONFIG_MODULES_USE_ELF_REL is not defined.
> 
> This is because there's a printk() that dereferences struct module to
> print the name of the module. But as struct module does not exist when
> CONFIG_MODULES is not defined we get this error:
> 
>    include/linux/moduleloader.h: In function 'apply_relocate':
> >> include/linux/moduleloader.h:48:63: error: dereferencing pointer to
> >> incomplete type  
>      printk(KERN_ERR "module %s: REL relocation unsupported\n", me->name);
> 								  ^
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Based-on-the-true-story-by: Steven Rostedt <rostedt@goodmis.org>

Confirms-rustys-story-ends-the-same-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
