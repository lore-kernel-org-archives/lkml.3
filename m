Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab3CDTT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:19:56 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:40278 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab3CDTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:19:54 -0500
MIME-Version: 1.0
In-Reply-To: <1362423581.4392.46.camel@falcor1>
References: <1362079419.2908.390.camel@falcor1.watson.ibm.com>
	<20130228213534.GF11360@redhat.com>
	<CACLa4pum7kXK+7+8ceVSuQsKDCFebdgGVYRTMKH9GQarqCEgMQ@mail.gmail.com>
	<1362102544.9158.35.camel@falcor1>
	<1362140107.9158.101.camel@falcor1>
	<20130301152839.GA3457@redhat.com>
	<20130301184027.GB3457@redhat.com>
	<1362166753.9158.169.camel@falcor1>
	<20130301213329.GC3457@redhat.com>
	<1362346944.18325.1.camel@falcor1>
	<20130304152919.GA15199@redhat.com>
	<1362423581.4392.46.camel@falcor1>
Date: Mon, 4 Mar 2013 14:19:52 -0500
Message-ID: <CACLa4psuj1EoY--a7rD95JCuC=ZduDB9AJqdS8T49SjSpUY5rg@mail.gmail.com>
Subject: Re: IMA: How to manage user space signing policy with others
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that is what he was suggesting.  It reuses the integrity code
but it loses the integrity flexibility.  I don't think it is a good
solution   :-(

On Mon, Mar 4, 2013 at 1:59 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Mon, 2013-03-04 at 10:29 -0500, Vivek Goyal wrote:
> [...]
>
>> Hi Mimi,
>>
>> If we decide to merge flags, then practically we modified the
>> ima_appraise_tcb policy. ima_appraise_tcb policy expects to cache the
>> results and we will not do that. And this conflict just grows if we
>> are forced to add more options in future.
>>
>> Also as you mentioned that in some cases flag merging is OR operation
>> and in another cases it might be AND operation. And we will most likely
>> end up hardcoding all this. I think slowly this is getting complicated
>> and as people add more complex rules things can quickly get out of hand.
>>
>> I am wondering that why are we trying to make multiple policies work
>> together. Can we try to keep it simple and say that at one point of
>> time only one policy can be effective. It could either be a built in
>> policy or user defined one. In fact that's how things are working right now.
>> User defined policy replaces built-in policy.
>>
>> For the sake of backward compatibility "ima_tcb" and "ima_appraise_tcb"
>> can co-exist together (like today). But ima_secureboot_policy will not
>> be compatible with other policies. I understand that there might be a
>> desire to use multiple policies together down the line, but I guess in
>> that case policies need to specified using "policy" interface. And
>> ima_secureboot will be odd man out here as it can not trust the root
>> to specify policy. So practically ima_secureboot will be disabled.
>>
>> We just have to provide an IMA interface so that caller can query what's
>> the effective policy currently. Say, IMA_POLICY_SECUREBOOT,
>> IMA_POLICY_TCB, or IMA_POLICY_USER. Caller of the bprm_check() or
>> bprm_post_load() can also check for current policy in force and give
>> CAP_SIGNED only if desired policy is in effect.
>>
>> This reduces our options but trying to make multiple policies co-exist
>> together is just making it complicated. We can take it up again when
>> somebody has a strong use case of using secureboot policy along with
>> other policies. In fact a user can still define a custom policy which
>> is mix of multiple policies. Just that it is not compatible with
>> "secureboot" policy because for that we can't trust "root" to define
>> policy.
>
> Let me get this straight.  You're suggesting that distros/users will
> need to make a Kconfig build decision of enabling secureboot, including
> the secureboot built-in policy, or be allowed to enable other integrity
> policies.  If RH enables secureboot, then no other integrity policy will
> be permitted.  Is that what you're saying, and if so, why would I agree
> to this?
>
> thanks,
>
> Mimi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
