Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FYRcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:32:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18625 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3FYRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:32:54 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=KQVShBsxvV6anhLZ10oA:9 a=QEXdDO2ut3YA:10 a=b9L0sdV2BR1Mxpvk:21 a=Zrp0ClEmbC8YRoEa:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372181572.18733.225.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Tue, 25 Jun 2013 13:32:52 -0400
In-Reply-To: <20130625172609.GA17050@redhat.com>
References: <20130623160452.GA11740@redhat.com>
	 <20130624020014.GB12811@redhat.com> <20130624143928.GA20659@redhat.com>
	 <1372085549.18733.162.camel@gandalf.local.home>
	 <20130624160012.GB5993@redhat.com>
	 <1372091079.18733.168.camel@gandalf.local.home>
	 <20130624165140.GB8572@redhat.com>
	 <1372093476.18733.170.camel@gandalf.local.home>
	 <20130625165556.GA16170@redhat.com>
	 <1372180890.18733.217.camel@gandalf.local.home>
	 <20130625172609.GA17050@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 13:26 -0400, Dave Jones wrote:
>  
>  > What's the above saying?  ffff880243288000->prev == 00ffff88023c6cdd but
>  > it should have been ffff88023c6cdd18? That is: ffff88023c6cdd18->next ==
>  > ffff880243288001?
> 
> It's saying something has done >>8 on a pointer, and stuck it in a list head.
> 

Yes, that's from the "01" in ffff880243288001. The flags held in the
pointer are never used as an address. That's always encapsulated with
rb_list_head(), which clears the flags and returns the actual address.

-- Steve


