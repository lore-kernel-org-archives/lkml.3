Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaC0RWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbaC0RWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:22:15 -0400
Date: Thu, 27 Mar 2014 13:20:54 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: James Morris <jmorris@namei.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com,
        akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-security-module@vger.kernel.org
Subject: [PATCH] LSM: Pass comm name via get_task_comm() [was: Re: [PATCH]
 Change task_struct->comm to use RCU.]
Message-ID: <20140327172054.GD14198@madcap2.tricolour.ca>
References: <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp>
 <20140307155415.GB16640@madcap2.tricolour.ca>
 <201403082143.BIH86903.QtVMHJFFOOSFOL@I-love.SAKURA.ne.jp>
 <20140310202155.GR16640@madcap2.tricolour.ca>
 <201403112102.HCC48418.LSOQFJOFOtFVHM@I-love.SAKURA.ne.jp>
 <201403112116.HIJ21362.OFVQJFtHOSOFLM@I-love.SAKURA.ne.jp>
 <alpine.LRH.2.02.1403120052040.23883@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403120052040.23883@tundra.namei.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/12, James Morris wrote:
> On Tue, 11 Mar 2014, Tetsuo Handa wrote:
> 
> > And the same phrase goes to James Morris...
> > 
> > If you are sure that it is safe to use get_task_comm() from
> > dump_common_audit_data() and you prefer locked version, please pick up below
> > patch via your git tree.
> > 
> > If you are unsure or prefer lockless version, I'll make a lockless version
> > using do_get_task_comm() proposed in this thread.
> 
> If you can't understand whether your patch is correct or not, don't ask me 
> to apply it to my tree.
> 
> If you're unsure, get it reviewed first.

Steve (see https://lkml.org/lkml/2014/3/11/218 ) and James,

Are the labels on data output in LSM_AUDIT_DATA_TASK even right?  The
general case gives pid and comm of current.  Then the
LSM_AUDIT_DATA_TASK case gives pid and comm from the task handed in in
the struct common_audit_data pointer.  They are a duplicate of the
general case without generating a new message.  I expect this will cause
ausearch to ignore those latter two fields.  Should the latter two be
renamed to something like ad_pid= and ad_comm= ?

Tetsuo, this conversation should have been on the linux-audit@redhat.com
list the whole time...

> - James

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
