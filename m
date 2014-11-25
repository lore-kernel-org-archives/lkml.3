Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaKYEU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 23:20:26 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36615 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaKYEUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 23:20:15 -0500
Message-ID: <1416889208.4335.127.camel@maggy.simpson.net>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, corbet@lwn.net, mingo@redhat.com,
        hpa@zytor.com, peterz@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com,
        mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it,
        kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org,
        gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com,
        oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com,
        keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu,
        vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-api@vger.kernel.org
Date: Mon, 24 Nov 2014 21:20:08 -0700
In-Reply-To: <alpine.DEB.2.11.1411242317380.6439@nanos>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 00:35 +0100, Thomas Gleixner wrote:

> Aside of the general issues I have with this (see the inline replies
> to your changelog) the overall impression of this patch is that it is
> a half baken and carelessly cobbled together extract of some data base
> specific kernel hackery, which I prefer not to see at all.

It culminates in a lumbering pseudo RT class of task disguised as a fair
class task.  I'd expect more gain by twiddling knobs to let last buddy
do its job than the 3% mentioned.

You could perhaps create a SUPER_BATCH class that is not wakeup
preempted by any fair class task of <= priority, not only BATCH and
IDLE, but that's as nasty as this patch, though loads prettier.  The
tick time thing doesn't feel right at all... if you're hurt badly by the
tick, you're likely holding the lock too long methinks.

	-Mike


