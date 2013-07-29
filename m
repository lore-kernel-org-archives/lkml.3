Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3G2Swe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:52:34 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49766 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab3G2Swc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:52:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@gmail.com>
References: <20130723174711.GE21100@mtj.dyndns.org>
	<8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz>
	<87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<20130729181354.GX715@cmpxchg.org>
Date: Mon, 29 Jul 2013 11:52:11 -0700
In-Reply-To: <20130729181354.GX715@cmpxchg.org> (Johannes Weiner's message of
	"Mon, 29 Jul 2013 14:13:54 -0400")
Message-ID: <87a9l5w65g.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/jF9K3BQDUJDgCrb1jZllrbV0iKR+QCnI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0066]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Johannes Weiner <hannes@cmpxchg.org>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.2-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> On Mon, Jul 29, 2013 at 10:03:35AM -0700, Eric W. Biederman wrote:
>> Yes.  From the looks of the looks of it the cgroup implementation is
>> rather badly borked right now, and definitely not up to the standards of
>> the other core pieces of the kernel.  One of the reasons I was rather
>> apalled when systemd started using them.  Until the code actually works
>> reliably and the races are removed most people's systems would be much
>> better off with cgroups compiled out.
>> 
>> A single unified hierarchy is a really nasty idea for the same set of
>> reasons. You have to recompile to disable a controller to see if it that
>> controller's bugs are what are causing problems on your production
>> system.  Compiles or even just a reboot is a very heavy hammer to ask
>> people to use when they are triaging a problem.
>
> That's not how it works.  You can always select which controllers you
> want to mount during runtime.  Unified hierarchy only means that there
> is one cgroup tree for all mounted controllers, rather than every
> controller having its own separate cgroup tree.
>
> If you are like most users and currently mount all controllers in the
> same directory so that their cgroup trees overlap and appear to be a
> single tree, nothing changes for you.

My practical need is that I need the ability modify which controllers I
am using on a per group basis.  So that I can make corrall new processes
in a different set of controllers than currently existing processes.

I might just be missing something but I don't see how to do that with
all of the controllers mounted to the same filesystem.

So while I currently have a single mount of cgroupfs, and don't yet see
a need for orthogonal classification of processes.  To keep bugs and
craziness under control I expect I will be implementing a mount of
cgroupfs per controller within a month.

But except for the need to limit the scope of bugs this is all getting
rather badly off topic.

Eric
