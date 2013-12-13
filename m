Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3LMJcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:32:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3LMJcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:32:23 -0500
Date: Fri, 13 Dec 2013 10:32:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Kees Cook <keescook@chromium.org>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
In-Reply-To: <20131213052712.GH23888@thunk.org>
Message-ID: <alpine.LRH.2.00.1312131028400.7125@twin.jikos.cz>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <20131213052712.GH23888@thunk.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Theodore Ts'o wrote:

> I am at least partially sympathetic to the concerns which Greg has
> raised, though.  At the very least the exploit() tags should also have
> a date stamp, so it we can automatically scan for exploit tags whose
> time has come and gone.

At least this is a non-issue, if you supply the CVE string (as 
Vegard's patchset proposed), as it implicitly contains a year it has been 
issued (which seems like sufficient granularity for this kind of 
tracking).

> I'm also worried about false positives getting triggered due to
> userspace bugs, corrupted file systems, or other random hardare
> failures.  This could be a support headache for distributions, and
> possibly for other kernel support organizations as well.  Given that
> attack authors will probably adapt their explots to only try them on
> known RHEL/SLES kernels that have the bug, it wouldn't surprise me if
> enterprise distro's such as Red Hat and SuSE will very likely simply
> not turn on the config option.

I of course can't really now talk officially about what we would do, as no 
internal discussion about this has happened, but my gut feeling is that we 
will be turning it off, exactly due to the reasons outlined above. 

We want to maintain sanity of our support engineers and not let them be 
drowned in figuring out these being false positives and then going through 
the pain of explaining this to the customer.

-- 
Jiri Kosina
SUSE Labs

