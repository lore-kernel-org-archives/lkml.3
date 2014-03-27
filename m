Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaC0SKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:10:34 -0400
Received: from emvm-gh1-uea08.nsa.gov ([63.239.67.9]:57711 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753968AbaC0SKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:10:33 -0400
X-TM-IMSS-Message-ID: <80cfd34c002644e3@nsa.gov>
Message-ID: <53346891.5030806@tycho.nsa.gov>
Date: Thu, 27 Mar 2014 14:06:09 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, James Morris <jmorris@namei.org>,
        Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com,
        akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] LSM: Pass comm name via get_task_comm() [was: Re: [PATCH]
 Change task_struct->comm to use RCU.]
References: <201403072120.BJB73489.OFMSOFHQFtOJLV@I-love.SAKURA.ne.jp> <20140307155415.GB16640@madcap2.tricolour.ca> <201403082143.BIH86903.QtVMHJFFOOSFOL@I-love.SAKURA.ne.jp> <20140310202155.GR16640@madcap2.tricolour.ca> <201403112102.HCC48418.LSOQFJOFOtFVHM@I-love.SAKURA.ne.jp> <201403112116.HIJ21362.OFVQJFtHOSOFLM@I-love.SAKURA.ne.jp> <alpine.LRH.2.02.1403120052040.23883@tundra.namei.org> <20140327172054.GD14198@madcap2.tricolour.ca>
In-Reply-To: <20140327172054.GD14198@madcap2.tricolour.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2014 01:20 PM, Richard Guy Briggs wrote:
> On 14/03/12, James Morris wrote:
>> On Tue, 11 Mar 2014, Tetsuo Handa wrote:
>>
>>> And the same phrase goes to James Morris...
>>>
>>> If you are sure that it is safe to use get_task_comm() from
>>> dump_common_audit_data() and you prefer locked version, please pick up below
>>> patch via your git tree.
>>>
>>> If you are unsure or prefer lockless version, I'll make a lockless version
>>> using do_get_task_comm() proposed in this thread.
>>
>> If you can't understand whether your patch is correct or not, don't ask me 
>> to apply it to my tree.
>>
>> If you're unsure, get it reviewed first.
> 
> Steve (see https://lkml.org/lkml/2014/3/11/218 ) and James,
> 
> Are the labels on data output in LSM_AUDIT_DATA_TASK even right?  The
> general case gives pid and comm of current.  Then the
> LSM_AUDIT_DATA_TASK case gives pid and comm from the task handed in in
> the struct common_audit_data pointer.  They are a duplicate of the
> general case without generating a new message.  I expect this will cause
> ausearch to ignore those latter two fields.  Should the latter two be
> renamed to something like ad_pid= and ad_comm= ?

Hmmm..only seems to be used by Smack.
SELinux had a tsk field in common_audit_data that was removed by
b466066.  This other tsk field seems to have been added for Smack by
6e837fb.

That said, it would be nice to have pid/comm info for the target of a
signal check as well as current.


