Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaJVTmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:42:09 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58615 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbaJVTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:42:06 -0400
Date: Wed, 22 Oct 2014 15:42:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Aditya Kali <adityakali@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Message-ID: <20141022194200.GA24009@htj.dyndns.org>
References: <CALCETrVkMtsnEh57jFZrdx5vHbz97BdO7OuupT+xVNnWpJjxng@mail.gmail.com>
 <87lhoayo59.fsf@x220.int.ebiederm.org>
 <CALCETrVFKvtHpTfY3kuE5ZTrwQAzuDmk6dm-mbQffDHAZmq-KQ@mail.gmail.com>
 <CAGr1F2Ee2MCKOwALR2YV7ppDmyHxO6+EsHqSc1+WcwKFPPQB0w@mail.gmail.com>
 <CALCETrWXDMRsexfvmh2CiMW4WX0ZLJ4pJvzHU55PEBk=NmnyZg@mail.gmail.com>
 <CAGr1F2FdQ4VF1_o7mdybZ-WhLLhFxdgkNnzotHOwnhLU8W+YCw@mail.gmail.com>
 <CALCETrXEAegFmSs2LnfSJR0tQmqZudnESDER8CoqKxOCBFMwdA@mail.gmail.com>
 <CAGr1F2HYGG9=jwugywD8tUdB+dOjN4z+3BSpqL_m2aaM+3Rz1A@mail.gmail.com>
 <CALCETrUtqozUE=Lr5d2dBKd_vaLzfVvVv8g6ZALz1MWqVzj9dQ@mail.gmail.com>
 <CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr1F2EBDCVrXZd7fOdffQ2C0c25T8co4wfxRc8P0Jb18yq2uQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 22, 2014 at 11:37:55AM -0700, Aditya Kali wrote:
...
> Actually, there is no right answer here. Our options are:
> * show relative path
> -- this will break userspace as /proc/<pid>/cgroup does not show
> relative paths today. This is also very ambiguous (is it relative to
> cgroupns-root or relative to /proc/<pid>cgroup file reader's cgroup?).

Let's go with this w/o pinning.  The only necessary feature for
cgroupns is making the /proc/*/cgroups relative to its own root.  It's
not like containers can avoid trusting its outside world anyway and
playing tricks with things like this tend to lead to weird surprises
down the road.  If userland messes up, userland messes up.

Thanks.

-- 
tejun
