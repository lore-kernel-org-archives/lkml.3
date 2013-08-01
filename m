Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab3HASwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:52:17 -0400
Received: from smtp105.biz.mail.gq1.yahoo.com ([98.137.12.180]:26771 "HELO
	smtp105.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756776Ab3HASwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:52:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ZXAn4CwVM1k_Q24s9tJFAj.pAxWMQPlIrPi1NnlkkDRa76X
 byInDec8gQDXpcHfMWLSo.LTGf4PRn5AkS7lrvT9G2h.Xj5SEbBd34_h6kr8
 jTSpCEc3.GpItu0rkI0JZxPecUpZ4QPjYuu08if3wZKw0FSHCK3OrdO4gvvJ
 FJ6EuIcBf4txSOCzQdY7Ne3GGp2q6egR3IFdgSh8dg5hY.J4VaP8ZqzHa.rB
 ZGtje3FMVmxeMT6TM.s6tNG671rabzbJFlnDVPfZNXM5m7ZjFjxAes0PH6Hx
 A_bgoacQP1AaJzqbH1xxAt7OtO68lZccEzDx1Osr4B0L87YODMMl_fznEtVt
 wVYnQJsGKyPQjgo98_0ww54ndiX.1X2c_pVl.USupU0fdX9uhy4zdE3MGZv.
 F0SMhg3p4VTLAq1I3q6zFATSzssJpgRDKVcWuATQpxkNolq6XW0g.OHw7kFg
 cixNxAGjJjK0pdahqTFBqVYfCHJ6kq1l6lJROibX03lqCEHqXF486molI33a
 85TJPI3ktC_jn
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp105.biz.mail.gq1.yahoo.com with SMTP; 01 Aug 2013 11:52:15 -0700 PDT
Message-ID: <51FAAE5E.4060801@schaufler-ca.com>
Date: Thu, 01 Aug 2013 11:52:14 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        SE Linux <selinux@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v14 3/6] LSM: Explicit individual LSM associations
References: <51F16CFB.6040603@schaufler-ca.com> <2122972.gxaeSjOpon@sifl> <51F97FF2.4040205@schaufler-ca.com> <1991449.AFacmybWrj@sifl>
In-Reply-To: <1991449.AFacmybWrj@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/2013 11:35 AM, Paul Moore wrote:
> On Wednesday, July 31, 2013 02:21:54 PM Casey Schaufler wrote:
>> On 7/31/2013 12:39 PM, Paul Moore wrote:
>>> On Wednesday, July 31, 2013 09:22:23 AM Casey Schaufler wrote:
>>>> On 7/30/2013 3:08 PM, Paul Moore wrote:
>>>>> On Thursday, July 25, 2013 11:32:11 AM Casey Schaufler wrote:
>>>>>> Subject: [PATCH v14 3/6] LSM: Explicit individual LSM associations
>>>>>>
>>>>>> Expand the /proc/.../attr interface set to help include
>>>>>> LSM specific entries as well as the traditional shared
>>>>>> "current", "prev" and "exec" entries. Each LSM that uses
>>>>>> one of the traditional interfaces gets it's own interface
>>>>>> prefixed with the LSM name for the ones it cares about.
>>>>>> Thus, we have "smack.current", "selinux.current" and
>>>>>> "apparmor.current" in addition to "current".
>>>>>>
>>>>>> Add two new interfaces under /sys/kernel/security.
>>>>>> The lsm interface displays the comma seperated list of
>>>>>> active LSMs. The present interface displays the name
>>>>>> of the LSM providing the traditional /proc/.../attr
>>>>>> interfaces. User space code should no longer have to
>>>>>> grub around in odd places to determine what LSM is
>>>>>> being used and thus what data is available to it.
>>>>>>
>>>>>> Introduce feature specific security operation vectors
>>>>>> for NetLabel, XFRM, secmark and presentation in the
>>>>>> traditional /proc/.../attr interfaces. This allows
>>>>>> proper handling of secids.
>>>>> Maybe I missed something, can you elaborate on this, perhaps even
>>>>> provide an example for us simple minded folk?
>>>> There are a set of facilities that (currently, at least)
>>>> can't be shared by multiple LSMs ...
>>> I should have been more specific.
>>>
>>> Thanks for the explanation, but that I understand the problems of stacking
>>> LSM/secids, we've had that conversation a few times now.  The explanation
>>> I was hoping for had to do with this sentence:
>>>
>>>  "Introduce feature specific security operation vectors for
>>>   NetLabel, XFRM, secmark and presentation in the traditional
>>>   /proc/.../attr interfaces."
>>>
>>> Can you explain this a bit more?  When I looked at the patch - and maybe
>>> I'm missing something - I didn't see anything in /proc that dealt with
>>> NetLabel, XFRM, and/or Secmark.
>> Just so. I have failed to communicate clearly.
>>
>>   "Each feature that requires support by a single, selected LSM
>>    is identified by a global pointer to that LSM's security_operations
>>    structure."
>>
>> NetLabel, XFRM and secmark are networking interfaces that can
>> send the security information from a single LSM along with the
>> packets of data.
>>
>> /proc/.../attr/current and SO_PEERSEC are interfaces that could
>> send information from multiple LSMs, but in most cases you have
>> to choose one LSM to placate your user space tools.
>>
>> In all of these cases it is necessary to identify the LSM to use.
>> Even though the end use is quite different the mechanism to support
>> the identification is the same.
> Okay, so if I understand everything correctly, there are no new entries in 
> /proc relating specifically to NetLabel, XFRM, or Secmark; although there are 
> new LSM specific entries for the general /proc entries that exist now.  Yes?

That's correct.

There is /sys/kernel/security/present, which tells you which LSM is going to
show up in /proc/.../attr/current.

Should we have /sys/kernel/security/XFRM, /sys/kernel/security/secmark,
/sys/kernel/security/NetLabel and /sys/kernel/security/SO_PEERCRED?


