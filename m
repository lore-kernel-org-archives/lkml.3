Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3IFOYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:24:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3IFOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:24:15 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BbXNHQx3NekA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fxhqf5xVK60A:10 a=20KFwNOVAAAA:8 a=o0iS_vPILNXsEjtbBAwA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 6 Sep 2013 10:24:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906102413.2e52d337@gandalf.local.home>
In-Reply-To: <20130906141852.GA18708@redhat.com>
References: <20130906011924.GA7970@redhat.com>
	<20130905212834.605408a4@gandalf.local.home>
	<20130906013455.GA10073@redhat.com>
	<20130905214455.101c6347@gandalf.local.home>
	<20130906014859.GB10073@redhat.com>
	<20130905215154.74c55e9a@gandalf.local.home>
	<20130906035827.GA13446@redhat.com>
	<20130906093252.02c748f5@gandalf.local.home>
	<20130906141852.GA18708@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013 10:18:52 -0400
Dave Jones <davej@redhat.com> wrote:


>  > > 00000000000028b0 <reiserfs_init_bitmap_cache>:
>  > > 
>  > >         return bh;
>  > > }
>  > > 
>  > > int reiserfs_init_bitmap_cache(struct super_block *sb)
>  > > {
>  > >     28b0:       e8 00 00 00 00          callq  28b5 <reiserfs_init_bitmap_cache+0x5>
>  > 
>  > That looks to be the call to fentry, but without being resolved. What
>  > we saw in the previous report wasn't 0xe8 but 0x14, and it was
>  > unresolved after loading!
>  > 
>  > I'm surprised that the module built with a different
>  > DEBUG_KOBJECT_RELEASE config would load. Does it not affect module
>  > versions?
>  
> # CONFIG_MODVERSIONS is not set
> 

Is it really safe to load modules that were compiled with different
options? Sounds like a failure in the install scripts to me.

Anyway, if you can send me the binary file, I can take a deeper look at
it.

-- Steve
