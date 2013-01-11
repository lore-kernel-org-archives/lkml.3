Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3AKA5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:57:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3AKA53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:57:29 -0500
Message-ID: <50EF6368.6070504@canonical.com>
Date: Thu, 10 Jan 2013 16:57:12 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com> <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org> <50EC8447.1000301@canonical.com> <alpine.LRH.2.02.1301100028160.5423@tundra.namei.org> <50EE9733.2060409@canonical.com> <87lic0sg09.fsf@xmission.com>
In-Reply-To: <87lic0sg09.fsf@xmission.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 04:46 PM, Eric W. Biederman wrote:
> John Johansen <john.johansen@canonical.com> writes:
> 
>> On 01/09/2013 05:28 AM, James Morris wrote:
>>> On Tue, 8 Jan 2013, John Johansen wrote:
>>>
>>>>> I'd say we need to see the actual use-case for Smack and Apparmor being 
>>>>> used together, along with at least one major distro committing to support 
>>>>> this.
>>>>>
>>>>>
>>>> Ubuntu is very interested in stacking
>>>
>>> Which modules?
>>>
>> Well Yama which has now been special cased, and in the past there has been
>> discussion about other special case LSMs like case is proposing for module
>> loading. There has been interest around both selinux + apparmor and
>> smack + apparmor. I am not sure of all of the use cases that have lead to
>> such question but some of them have been around containers, with say
>> selinux on the host and apparmor in the container, or visa versa.
> 
> When a distro is run in a container it is desirable to be able to run
> the distro's security policy in that container.  Ideally this will get
> addressed by being able to do some level of per user namespace stacking.
> Say selinux outside and apparmor inside a container.
> 
> I think this would take a little more work than what Casey has currently
> devised but I am hopeful an additional layer of stacking can be added
> after Casey has merged the basic layer of stacking.
> 
Right the general case will take more, but doing things like selinux on
the outside and apparmor inside are doable right now. And we are working
on supporting stacked apparmor policy right now so apparmor outside and
a different apparmor policy inside will be doable soon.

