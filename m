Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaKDNqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:46:47 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:62743 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaKDNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:46:42 -0500
Date: Tue, 4 Nov 2014 08:46:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Aditya Kali <adityakali@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Li Zefan <lizefan@huawei.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Rohit Jnagal <jnagal@google.com>
Subject: Re: [PATCHv2 7/7] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Message-ID: <20141104134633.GA14014@htj.dyndns.org>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
 <1414783141-6947-8-git-send-email-adityakali@google.com>
 <87y4rvrakn.fsf@x220.int.ebiederm.org>
 <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGr1F2Hd_PS_AscBGMXdZC9qkHGRUp-MeQvJksDOQkRBB3RGoA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Aditya.

On Mon, Nov 03, 2014 at 02:43:47PM -0800, Aditya Kali wrote:
> I agree that this is effectively bind-mounting, but doing this in kernel
> makes it really convenient for the userspace. The process that sets up the
> container doesn't need to care whether it should bind-mount cgroupfs inside
> the container or not. The tasks inside the container can mount cgroupfs on
> as-needed basis. The root container manager can simply unshare cgroupns and
> forget about the internal setup. I think this is useful just for the reason
> that it makes life much simpler for userspace.

If it's okay to require userland to just do bind mounting, I'd be far
happier with that.  cgroup mount code is already overcomplicated
because of the dynamic matching of supers to mounts when it could just
have told userland to use bind mounting.  Doesn't the host side have
to set up some of the filesystem layouts anyway?  Does it really
matter that we require the host to set up cgroup hierarchy too?

Thanks.

-- 
tejun
