Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3CRTTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:19:09 -0400
Received: from nm19-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.25]:44006
	"EHLO nm19-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745Ab3CRTTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:19:05 -0400
X-Yahoo-Newman-Id: 68894.93082.bm@smtp101.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NhuNTMEVM1kiLryQqj0GKSCtRSuEZfpf1nsOFyq5cYsEr_6
 ns8ID8x8lGgYlNG4omgjPl0PYnSn0a5XpuGDzAcR1fKVqdZ8dnOFLhLouZ0B
 ae6xPlR3Pwjx.2pjUjmlFm6wo0qkGMnV_nS9JF3Mgr2Cc.R7i0M_UyFKhsqX
 LU63OkwPIXatjGRV3sqvmbxhAp44JB347r0tlPzbDF0MLESf8q_qBNEFw.sL
 1BD5n7RwWpA8H3lKmyhKkWscG5RLuCYilCW1NhFKHygjQDZ0ecD2FnsY_1Um
 C3iCtPcVKIYsByKJBOhxIVHAzKgjTm8BzJXt0UrFPsFkJl9Jxa9RpkfPacyr
 48YNpLtB_PwsLZ31b_pf3qCedFutrnTMKhZwAIcyK77F9CBiQtk3Qe0L6USk
 13jXfJgCrRoQ5R9WIG2R9v7UpQqXP2zViNYirMgCo.SXyXNnYYLzT42QCgEj
 AfNRjWQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@50.131.111.212 with plain)
        by smtp101.biz.mail.bf1.yahoo.com with SMTP; 18 Mar 2013 12:19:02 -0700 PDT
Message-ID: <514768AF.4010504@schaufler-ca.com>
Date: Mon, 18 Mar 2013 12:19:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, dmitry.kasatkin@intel.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com> <1363379758-10071-4-git-send-email-vgoyal@redhat.com> <51438EDB.3050300@schaufler-ca.com> <20130318170552.GG20743@redhat.com> <514753DC.4030609@schaufler-ca.com> <20130318183028.GB28061@redhat.com>
In-Reply-To: <20130318183028.GB28061@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/2013 11:30 AM, Vivek Goyal wrote:
> On Mon, Mar 18, 2013 at 10:50:21AM -0700, Casey Schaufler wrote:
>> On 3/18/2013 10:05 AM, Vivek Goyal wrote:
>>> On Fri, Mar 15, 2013 at 02:12:59PM -0700, Casey Schaufler wrote:
>>>> On 3/15/2013 1:35 PM, Vivek Goyal wrote:
>>>>> Create a new capability CAP_SIGNED which can be given to signed executables.
>>>> This would drive anyone who is trying to use
>>>> capabilities as the privilege mechanism it is
>>>> intended to be absolutely crazy.
>>> Will calling it CAP_SIGNED_SERVICES help. I intend to use it as
>>> capability (and not just as a flag for task attribute).
>> No, the name is not the issue.
>>
>>> I think primary difference here is that this capability is controlled
>>> by kernel and only validly signed processes get it.
>> Applications are allowed to manipulate their capability sets
>> in well defined ways. The behavior of file based capabilities
>> is also explicitly defined. The behavior you are proposing would
>> violate both of these mechanisms. 
>>
>>>> Capabilities aren't just random attribute bits. They
>>>> indicate that a task has permission to violate a
>>>> system policy (e.g. change the mode bits of a file
>>>> the user doesn't own). Think about how this will
>>>> interact with programs using file based capabilities.
>>> It is a separate capability. I am not sure why it would
>>> interfere with other capabilities or functionality out there.
>> The behavior of capabilities is uniform. You can't have one
>> capability that behaves differently from the others. If a
>> file is unsigned but has CAP_SIGNED in the file capability
>> set what do you expect to happen? Do you want a signed
>> application to be able to drop and raise the fact that it
>> is signed?
> I have already removed this capability from bounding set. Behavior
> I am looking for is that nobody should be able to set CAP_SIGNED
> as file capability. I will look into that.

No! You are not listening. All capabilities work the same way.
If the file capabilities say ALL that means ALL. You do not get
to put a hole in the middle of the file based capabilities.


> I am thinking of this more as kernel managed capability. It is
> not in bounding set of any process and it can not be set as file
> capability.

I heard that. No, you don't get to do that. All capabilities
work the same way. Your attribute does not behave the way
capabilities do, so you have to implement it some other way.


> It is a new capability, so no existing user application should
> be trying to set it.

There are (and will be) applications that raise and drop all
capabilities, and that do so for good reasons.

> I think the only surprise would be that they can't drop it. If
> that's a concern, may be we can allow dropping the capability.
> But the side affect is that there is no way to gain it back for
> the life time of process.

Right. And that is a change to the capability mechanism. No, you
don't get to do that.

You don't want a new capability. You want a new attribute that
behaves differently than capabilities do. You need to come up
with a different way to implement your attribute. You do not get
to change the way capabilities work.

>> I expect that you don't want your attribute that indicates
>> that the binary was signed to behave the same way that
>> capabilities do. Like I said, capabilities are not just
>> attribute bits. You need a different kind of process attribute
>> to indicate that the binary was signed.
> I think I need more than process attribute. One of the things
> I am looking for is that signed processes run locked in memory
> and nobody (i think no unsigned process) is able to do ptrace() on it.
> Using the notion of capability might help here.

There are already capabilities associated with ptrace. It would
be simple to add a check for signatures in cap_ptrace_access_check.


>> When (if ever) we have multiple LSM support you might consider
>> doing this as a small LSM. Until then, you're going to need a
>> different way to express the signature attribute.
> I am not sure why you are viewing it as necessarily as attribute only.
> I am thinking more in terms of that in certain situations, user space
> processes can't perform certain operations (like kexec) untile and
> unless process has the capability CAP_SIGNED_SERVICES. And this capability
> is granted if upon exec() process signature are verified.

Sigh. You need the process attribute to make the checks against. The
process capability set, uids and groups are all examples of process
attributes that exist today.

> So yes it is little different from how capabilities are managed
> currently. But is it very hard to extend the current capability definition
> and include the fact that kernel can give additional capabilities to
> processes based on some other factors.

Yes. That is correct. That is why we have the LSM facility. The
unfortunate fact is that you only get one LSM at a time today. I
am working on fixing that, but there is still work to be done
before it will be ready for upstream.

If signed application controls are deemed sufficiently important
and your implementation sound you should be able to get the signature
attribute and the checks on that attribute into the base system.


> Thanks
> Vivek
>

