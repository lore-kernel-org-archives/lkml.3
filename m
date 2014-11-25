Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaKYNjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:39:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaKYNjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:39:43 -0500
Message-ID: <5474863A.6010307@redhat.com>
Date: Tue, 25 Nov 2014 08:38:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Khalid Aziz <khalid.aziz@oracle.com>, tglx@linutronix.de, corbet@lwn.net,
        mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
 (was: Pre-emption control for userspace)
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>	 <5473E388.6000605@redhat.com> <1416897050.20575.18.camel@linux-t7sj.site>
In-Reply-To: <1416897050.20575.18.camel@linux-t7sj.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/25/2014 01:30 AM, Davidlohr Bueso wrote:
> On Mon, 2014-11-24 at 21:03 -0500, Rik van Riel wrote:
>> I can see this "solution" help mostly with userspace spinlocks, 
>> which are relics of a past era that need to die. There is no way
>> userspace spinlocks will not fail miserably on virtual machines,
>> and it is time to get rid of them.
> 
> No, not really. Spinlocks are still very useful on bare metal. 
> Virtualization is not the only thing out there.

How many people are going to build two different binaries,
one for bare metal, and one for virtualized environments?

I suspect the vast majority of applications will only be
built once, and it would be nice if it wasn't using a
locking scheme that broke horribly on a significant part
of the deployments...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUdIY6AAoJEM553pKExN6DaisH+wWzTc+onHTsPUXs6EU/s+sa
lp3KFWmRQACPjiWSyIfg7aWFxakiS8BQ4ypbXdC/55lHuX/KMm/1k3zZF/lHiyYA
vIwfPUX7TnZxgYGVGk++nrCTffQImAc5RXlCBU6Hp6dHxV5Pead6S9afO8dfOeVu
80cpsqCyUqX+jhMDKq6NkIE0mCMb/U4L0cqo7m67h7PTlWmj8V64PKJjvkDu48O1
tPd+6jj4xDoEl8dde00EMaYETA6Utngt8+LslV1hMB1nxn82aNIGJnEqQco4WGXH
gE8Pkn+iToBe1hPF63MVZFJHRzXPUOAoaBCTgu7+l9LLDkfBgv2A/ckh5NLUrd8=
=41Jl
-----END PGP SIGNATURE-----
