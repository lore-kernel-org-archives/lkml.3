Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3AKSNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:13:54 -0500
Received: from nm4.access.bullet.mail.mud.yahoo.com ([66.94.237.205]:23780
	"EHLO nm4.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012Ab3AKSNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:13:48 -0500
X-Yahoo-Newman-Id: 294751.7484.bm@smtp110.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iCuZhv0VM1k7gA8dOa.OXYGQOcdbowhpoBEXmX5IRExuXQK
 8XEo_McLsxcSfDwUUH_S0YwG21hAFXTFim3Q3Ilql6OqppCebi7tbjuhPRdH
 tnxu2YFXFIVaz722SNAdXRid7rCgSLIY2RsF0BmyHowqxVej8nGqGNVBAIZ.
 R.3J_0RibaLw8KQ_pQy1.j24Nu3sYUlNEonVarA5KmD77OkpHdX_2iaAoGao
 0GxXhjMiRJMQ75SxhkVXrZcC.Yv9nHhPgphHNLzC2og9G7ZeKBHVKSXf07.s
 lswyk7tmzEbpL.TbaNi7DRc1upLQh7QPEMJ_HWatpjCRV7CgnxWwkb2BuQvH
 UWL5PDm0xhd1wJbjQo8Wb01GrOftip7QAf_Fev5mz6Rxr7pU5l1rGcUJk9Aq
 nyOiYW3WqGndUYWRy1AoteZTJI6dw8CQ44dcZ2GQ2aHzSet1gHDVTr1zTH7W
 TtOsKRyLIQwG69gB47A--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50F05656.5060301@schaufler-ca.com>
Date: Fri, 11 Jan 2013 10:13:42 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com> <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org> <50EC8447.1000301@canonical.com> <alpine.LRH.2.02.1301100028160.5423@tundra.namei.org> <50EE9733.2060409@canonical.com> <87lic0sg09.fsf@xmission.com>
In-Reply-To: <87lic0sg09.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2013 4:46 PM, Eric W. Biederman wrote:
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
>>> Which modules?
>>>
>> Well Yama which has now been special cased, and in the past there has been
>> discussion about other special case LSMs like case is proposing for module
>> loading. There has been interest around both selinux + apparmor and
>> smack + apparmor. I am not sure of all of the use cases that have lead to
>> such question but some of them have been around containers, with say
>> selinux on the host and apparmor in the container, or visa versa.
> When a distro is run in a container it is desirable to be able to run
> the distro's security policy in that container.  Ideally this will get
> addressed by being able to do some level of per user namespace stacking.
> Say selinux outside and apparmor inside a container.
>
> I think this would take a little more work than what Casey has currently
> devised but I am hopeful an additional layer of stacking can be added
> after Casey has merged the basic layer of stacking.

Would that be per-container LSM lists? I hadn't thought about
doing that, and don't know how you might implement it, but I
suppose it could work.

>
> Eric
>

