Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaHMRwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:52:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaHMRwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:52:03 -0400
Message-ID: <53EBA560.8030404@redhat.com>
Date: Wed, 13 Aug 2014 13:50:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time: drop do_sys_times spinlock
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813174048.GV9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140813174048.GV9918@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/13/2014 01:40 PM, Peter Zijlstra wrote:

> So the problem with the above is the lack of fwd progress; if
> there's enough clone()/exit() happening in the thread group (and
> the more CPUs the more possible), we'll keep repeating.

We can fall back to taking the lock if we circle around,
or if there is a writer active when we are in seqcount_read,
similar to what the semaphore (ipc/sem.c) code is doing.

read_seqbegin_or_lock would do the trick...
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT66VgAAoJEM553pKExN6D1lMH/3/+5vCSsVAyOVLi/xFb7lmt
BhRoMJO5MtDaNV32thh8kv9m1Q6r8FqtExUN6aZkTGj6Gp8nAnKFi0tR7na6nwfv
dlxCP9Q8ETiGhhE1jcJLOfv8lut5PzkR8LvorUHIU3v9wuZMZHEZB4dV/Uc6Ntsf
Ek4iT6QYUUGz8zgmPN4DWZ3k86vof3BOQjzFCaQMMTp4W2fGUVNpTEG+h9fHv42w
SzLwCUpj/9UQ2Y+V7rQki2bKtcXNjZoOFMdcNL9AsAaeAbSWQyxXCGf5ku2kXKS6
GnxgXNX2rDGhkL8g61ZB3hq1bbWkgPDte8run9wKI3OU1Z0Pg+oxpe0HFC5Hoag=
=SACY
-----END PGP SIGNATURE-----
