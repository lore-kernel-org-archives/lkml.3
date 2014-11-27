Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906AbaK0PLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:11:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24227 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaK0PLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:11:06 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-6c-54773f0691f9
Message-id: <1417101060.1805.21.camel@samsung.com>
Subject: Re: [RFC] lsm: namespace hooks
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Paul Moore <pmoore@redhat.com>,
        Kees Cook <keescook@chromium.org>, Miklos Szeredi <mszeredi@suse.cz>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Dario Faggioli <raistlin@linux.it>, Alex Thorlton <athorlton@sgi.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Lukasz Pawelczyk <havner@gmail.com>
Date: Thu, 27 Nov 2014 16:11:00 +0100
In-reply-to: <54773CE7.5040303@nod.at>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
 <1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
 <CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
 <1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
 <1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0ySYRjH9/J9fnxQbJ9k+s1cJZvUXJq2Lt5cWd3Ue1mN1TpsisrUJmoQ
	HrpCF8xInWZlkalT02wupnjAQyqiaVpKeMBseIhlMcXD1DxgmYgX3v2f5/n9n/9z8ZAY14p7
	k7Hx90WSeGEcj2Djff+6hwKI88mCIP0CBxZoqgg4a87H4Hj9BgGrym0E1C9M4HAu3YHDrfqH
	TLg1cwJmW6/BHu0EgOuVTQB+fiyG2tUMAg42FRBwIfMHAQvsdgIO52uY0NRezIAmhwWDlUvf
	cVjXpgCwO6udAZdGNpjQbKnFYF7jLIDKsmoG7E/7hcMBYz8TDta9xODA3263C4eRWp5FoFfy
	rzhqVFuYqLhGhkaabyLtW39U2mJjoJ4XDhwpK1pxlDdaAdC3wnto8ecYjj4VrhNovnWYQF1t
	JQSymG2MKx632GejRHGxSSLJydBwdsxUphxL7MVT9Cu5QA4MmAqwSJo6TU/PtzBc2pM2jmsI
	FWCTXOoNoPWbpZir2AL0So0COCkOdYoeq7Dv6APUMdpQ5GA6NUEF0avGDztbPbb7c7ZnO5sw
	6jWLNumytyGSxCk/WjMd4WRYFJ9+mla0m2Zi0AuTDsI5wLbNTwpLds/zp+dV67gr2J1eyxvH
	XcwRWltlx3IApd5jUe/B1HuwYoC9AwdFsshEaUS0ODhQKhRLZfHRgZEJ4hrgeoxlHSj9GNIB
	KBLw9nPCrUkCrpswSZoq7gA0ifE8OOnnkgVcTpQw9YFIkhAmkcWJpB2AQbK85eCqzstgaAs7
	5P3IPtbH+51VpqB0iuNfrJOhE+G3Yzq7fOzK93cFm3L3sqBL3isXvVR1tTlmQbVvWe/avj+9
	Rn0xq/PGKrUYsNTF1ATeUR0dTGZmRJWGXG9UKRv4KVZ0xrNhdHm6OS2nKZsfJvbjTz3X+8z4
	WgW55QWXw4a8NDxcGiMM9sckUuF/TZH+sfYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-11-27 at 16:01 +0100, Richard Weinberger wrote:
> Am 27.11.2014 um 15:44 schrieb Lukasz Pawelczyk:
> > True, the last one is 0x80000000. I did not notice that. Thanks for
> > pointing out.
> 
> Isn't this CLONE_IO?

Yes, I was merely noticing out loud that it's the last bit of 32bit.

After close look though the 0x00001000 appears to be unused

> > Any suggestion on what can be done here? New syscal with flags2?
> 
> I'm not sure. But a new syscall would be a candidate.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



