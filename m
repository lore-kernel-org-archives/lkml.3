Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaFQJsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:48:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbaFQJsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:48:46 -0400
Message-ID: <53A00EDB.3050108@redhat.com>
Date: Tue, 17 Jun 2014 11:48:11 +0200
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com> <20140320153250.GC20618@thunk.org> <CANq1E4SUXrzAV8FS8HVYxnRVb1oOR6HSTyucJzyFs5PuS5Y88A@mail.gmail.com> <20140320163806.GA10440@thunk.org> <5346ED93.9040500@amacapital.net> <20140410203246.GB31614@thunk.org> <CALCETrVmaGNCxo-L4-dPbUev3VXXEPR7xBzo3Fux6ny7yh_Gzw@mail.gmail.com>
In-Reply-To: <CALCETrVmaGNCxo-L4-dPbUev3VXXEPR7xBzo3Fux6ny7yh_Gzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 10:37 PM, Andy Lutomirski wrote:

> It occurs to me that, before going nuts with these kinds of flags, it
> may pay to just try to fix the /proc/self/fd issue for real -- we
> could just make open("/proc/self/fd/3", O_RDWR) fail if fd 3 is
> read-only.  That may be enough for the file sealing thing.

Increasing privilege on O_PATH descriptors via access through 
/proc/self/fd is part of the userspace API.  The same thing might be 
true for O_RDONLY descriptors, but it's a bit less likely that there are 
any users out there.  In any case, I'm not sure it makes sense to plug 
the O_RDONLY hole while leaving the O_PATH hole open.

-- 
Florian Weimer / Red Hat Product Security Team
