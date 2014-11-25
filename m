Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaKYCFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:05:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaKYCFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:05:31 -0500
Message-ID: <5473E388.6000605@redhat.com>
Date: Mon, 24 Nov 2014 21:03:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Khalid Aziz <khalid.aziz@oracle.com>, tglx@linutronix.de, corbet@lwn.net,
        mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a timeslice
 (was: Pre-emption control for userspace)
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
In-Reply-To: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2014 03:56 PM, Khalid Aziz wrote:
> sched/fair: Add advisory flag for borrowing a timeslice
> 
> This patch adds a way for a task to request to borrow one
> timeslice from future if it is about to be preempted, so it could
> delay preemption and complete any critical task it is in the middle
> of.
> 
> This feature helps with performance on databases and has been used
> for many years on other OSs by the databases. This feature helps in
> situation where a task acquires a lock before performing a critical
> operation on the database and happens to get preempted

Why don't the other tasks that want the lock sleep on the
lock?

I can see this "solution" help mostly with userspace spinlocks,
which are relics of a past era that need to die. There is no
way userspace spinlocks will not fail miserably on virtual
machines, and it is time to get rid of them.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUc+OIAAoJEM553pKExN6DF/oIAJ+ldPQZBMIxJLK4dmAwCuwu
OLK8sEyOMbg7/0u7EcfJaeWMhxIN+etnK9535TsIpm7ojBeBcuMvXv/K7u5gD6V4
+yU4mV/rUCccolXruaHJqaFZqOg06qmJ0FdzJNyBrsMclgGnfTL8m8p5dlCOMMLZ
11N3imtrrJekigAmn/r9DCr75cGgfpIjPqE1yHc5NhiZ2uPmAS2qvefIZsg+88PH
8M0dOjgIWQKi9SkB6K2OSy7A/fKwyf9DJ3/OKRovA6AHfszvqCU1WVOoYRoO0CPG
v/zOYxIi8FIwi9LT50pM62zcpXVMYddN5etGa9qh4nI7oxXYKniH4JzwZdWDYwo=
=EymR
-----END PGP SIGNATURE-----
