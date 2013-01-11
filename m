Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3AKArF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:47:05 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38372 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3AKArD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:47:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>,
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
	<50EE9733.2060409@canonical.com>
Date: Thu, 10 Jan 2013 16:46:46 -0800
In-Reply-To: <50EE9733.2060409@canonical.com> (John Johansen's message of
	"Thu, 10 Jan 2013 02:25:55 -0800")
Message-ID: <87lic0sg09.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19qTkj9xEkW7jqKf1fys5rUqmRjMiscmxM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0352]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;John Johansen <john.johansen@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen <john.johansen@canonical.com> writes:

> On 01/09/2013 05:28 AM, James Morris wrote:
>> On Tue, 8 Jan 2013, John Johansen wrote:
>> 
>>>> I'd say we need to see the actual use-case for Smack and Apparmor being 
>>>> used together, along with at least one major distro committing to support 
>>>> this.
>>>>
>>>>
>>> Ubuntu is very interested in stacking
>> 
>> Which modules?
>> 
> Well Yama which has now been special cased, and in the past there has been
> discussion about other special case LSMs like case is proposing for module
> loading. There has been interest around both selinux + apparmor and
> smack + apparmor. I am not sure of all of the use cases that have lead to
> such question but some of them have been around containers, with say
> selinux on the host and apparmor in the container, or visa versa.

When a distro is run in a container it is desirable to be able to run
the distro's security policy in that container.  Ideally this will get
addressed by being able to do some level of per user namespace stacking.
Say selinux outside and apparmor inside a container.

I think this would take a little more work than what Casey has currently
devised but I am hopeful an additional layer of stacking can be added
after Casey has merged the basic layer of stacking.

Eric
