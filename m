Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161741Ab3DENuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161203Ab3DENuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:50:15 -0400
Date: Fri, 5 Apr 2013 09:49:29 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4 object already free.
Message-ID: <20130405134929.GA1648@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Jan Kara <jack@suse.cz>,
	tytso@mit.edu, Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <20130329155855.GB5313@redhat.com>
 <20130405102553.GB3848@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405102553.GB3848@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 12:25:53PM +0200, Jan Kara wrote:
 
 > > [   93.672257]  [<ffffffff812c2da9>] sys_msgctl+0x139/0x400
 > > [   93.674641]  [<ffffffff816c5d4d>] ? retint_swapgs+0xe/0x13
 > > [   93.677056]  [<ffffffff810b6c55>] ? trace_hardirqs_on_caller+0x115/0x1a0
 > > [   93.679626]  [<ffffffff8134b39e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 > > [   93.682159]  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
 > > [   93.799329] FIX kmalloc-64: Object at 0xffff88009997e620 not freed
 >   And then sys_msgctl() came and wanted to free it again without
 > allocating. So it looks like a problem with IPC? 

Seems plausible, considering the bugs Linus & others found there in the 
last week.  Should be fixed now, so I'll holler if I see this again.

thanks,

	Dave

 
