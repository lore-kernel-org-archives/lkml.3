Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3AKTf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:35:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44313 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3AKTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:35:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: John Johansen <john.johansen@canonical.com>,
        James Morris <jmorris@namei.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <50EB7C50.3070605@schaufler-ca.com>
	<20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
	<50EB9A5E.1080306@schaufler-ca.com>
	<alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
	<50EC8447.1000301@canonical.com>
	<alpine.LRH.2.02.1301100028160.5423@tundra.namei.org>
	<50EE9733.2060409@canonical.com> <87lic0sg09.fsf@xmission.com>
	<50F05656.5060301@schaufler-ca.com>
Date: Fri, 11 Jan 2013 11:35:11 -0800
In-Reply-To: <50F05656.5060301@schaufler-ca.com> (Casey Schaufler's message of
	"Fri, 11 Jan 2013 10:13:42 -0800")
Message-ID: <87d2xb3440.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Iom57miSZQNbR3G+wv8QHKs1+/ncwOUE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2399]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

>> When a distro is run in a container it is desirable to be able to run
>> the distro's security policy in that container.  Ideally this will get
>> addressed by being able to do some level of per user namespace stacking.
>> Say selinux outside and apparmor inside a container.
>>
>> I think this would take a little more work than what Casey has currently
>> devised but I am hopeful an additional layer of stacking can be added
>> after Casey has merged the basic layer of stacking.
>
> Would that be per-container LSM lists? I hadn't thought about
> doing that, and don't know how you might implement it, but I
> suppose it could work.

Essentially per-container LSM lists.  The semantics would be that
first you perform the global LSM list checks, and then you perform
the container LSM list checks (with additional layers if containers are
nested).  For LSM modules that depend on security labels I think there
would be a conflict that would prevent nesting.

This is already implemented for capabilities.  Something is already
happening with apparmor.

In practice it may just be a matter of getting the LSMs to be aware of
the containers rather than having per container LSM lists.  Especially
as all of the hooks are called every time for every LSM.

The important part is that the effect be nested policy.  Having nested calls
is likely to be unnecessary and inefficient if there is much nesting of
containers going on.

Eric

