Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab3FSVDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:03:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58359 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845Ab3FSVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:03:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Paris <eparis@redhat.com>
Cc: Aristeu Rozanski <aris@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, serge.hallyn@ubuntu.com,
        matthltc@linux.vnet.ibm.com, sgrubb@redhat.com
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
	<20130619204927.GJ3212@redhat.com>
	<1371675095.16587.5.camel@dhcp137-13.rdu.redhat.com>
Importance: high
Date: Wed, 19 Jun 2013 14:03:17 -0700
In-Reply-To: <1371675095.16587.5.camel@dhcp137-13.rdu.redhat.com> (Eric
	Paris's message of "Wed, 19 Jun 2013 16:51:35 -0400")
Message-ID: <87a9mlu82y.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ATBs37O5KEeK/bZ5/7nRlWskmxipwOdE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0770]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Paris <eparis@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Part1 PATCH 00/22] Add namespace support for audit
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> On Wed, 2013-06-19 at 16:49 -0400, Aristeu Rozanski wrote:
>> On Wed, Jun 19, 2013 at 09:53:32AM +0800, Gao feng wrote:
>> > This patchset is first part of namespace support for audit.
>> > in this patchset, the mainly resources of audit system have
>> > been isolated. the audit filter, rules havn't been isolated
>> > now. It will be implemented in Part2. We finished the isolation
>> > of user audit message in this patchset.
>> > 
>> > I choose to assign audit to the user namespace.
>> > Right now,there are six kinds of namespaces, such as
>> > net, mount, ipc, pid, uts and user. the first five
>> > namespaces have special usage. the audit isn't suitable to
>> > belong to these five namespaces, And since the flag of system
>> > call clone is in short supply, we can't provide a new flag such
>> > as CLONE_NEWAUDIT to enable audit namespace separately. so the
>> > user namespace may be the best choice.
>> 
>> I thought it was said on the last submission that to tie userns and
>> audit namespace would be a bad idea?
>
> I consider it a non-starter.  unpriv users are allowed to launch their
> own user namespace.  The whole point of audit is to have only a priv
> user be allowed to make changes.  If you tied audit namespace to user
> namespace you grant an unpriv user the ability to modify audit.
>
> NAK.
>
> If there are not clone flags you will either need to only do this from
> unshare and not from clone, or get more flags to clone

I completely agree that only priveleged user should be able to make
changes.

On the flip side, I don't know if this is at all interesting unless we
have a solution that works for users in unprivileged user namespaces.
Something like having the possibility of two or more instances of audit
working on every action.  One for each layer of privilege.

Gao feng, how do you want to use the audit infrastructure?

Eric

