Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaDPSfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:35:37 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:52491 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633AbaDPSff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140416182530.GB550@redhat.com>
References: <CALCETrURHNmLyccRiF_W8o2ozRMR4AaCjUE=_PU8z1+Pq6X2jQ@mail.gmail.com>
 <20140416002010.GA5035@redhat.com> <CALCETrWzHYN3kKcmDTFDfGhZqE4u9+6XDtiOu5nncbK_7KKH0g@mail.gmail.com>
 <20140416.085743.1614257692560892039.davem@davemloft.net> <CALCETrVv8SPM5xjOVGy7qO2aq3FKtG2uG57J49nO7Wy0-gg0Ew@mail.gmail.com>
 <1397664837.19767.410.camel@willson.li.ssimo.org> <CALCETrXn7b6UuALpGUVoyQYfR2uzk5tj2ABV=dkvtFNgqM5sxQ@mail.gmail.com>
 <20140416180642.GG31074@redhat.com> <CALCETrVUw5+vCCONy1VTXpskbY_eZFo2CtbehwV5Mhj4d4+icw@mail.gmail.com>
 <20140416182530.GB550@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 16 Apr 2014 11:35:13 -0700
Message-ID: <CALCETrUs1js3Br81ZkiQnsuWduzOiqDe3aV0K_z_zw0znSuiag@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Implement SO_PASSCGROUP to enable passing cgroup path
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simo Sorce <ssorce@redhat.com>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lpoetter@redhat.com, cgroups@vger.kernel.org, kay@redhat.com,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 11:25 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Apr 16, 2014 at 11:13:31AM -0700, Andy Lutomirski wrote:
>
> [..]
>> > Ok, so passing cgroup information is not necessarily a problem as long
>> > as it is not used for authentication. So say somebody is just logging
>> > all the client request and which cgroup client was in, that should not
>> > be a problem.
>>
>> Do you consider correct attribution of logging messages to be
>> important?  If so, then this is a kind of authentication, albeit one
>> where the impact of screwing it up is a bit lower.
>
> So not passing cgroup information makes attribution more correct. Just
> logging of information is authentication how? Both kernel and user space
> log message into /var/log/messages and kernel messages are prefixed with
> "kernel". So this somehow becomes are sort of authentication. I don't
> get it.

I did a bad job of explaining what I meant.

I think that, currently, log lines can be correctly attributed to the
kernel or to userspace, but determining where in userspace a log line
came from is a bit flaky.  One of the goals of these patches is to
make log attribution less flaky.  But if you want log attribution to
be completely correct, even in the presence of malicious programs,
then I think that the current patches aren't quite there.

Is the reason that you don't want to modify the senders because you
want users of syslog(3) to get the new behavior?  If so, I think it
would be nice to update glibc to fix that, but maybe the kernel should
cooperate, and maybe SO_PEERCGROUP is a decent way to handle this.

I still think that SO_PASSCGROUP, as currently designed, is problematic.
