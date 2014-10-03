Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaJCIXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:23:49 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:35718 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJCIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:23:45 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.172.182]
In-Reply-To: <20141002200612.GQ14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com>
 <1411768637-6809-6-git-send-email-mcgrof@do-not-panic.com>
 <CAG-2HqWmVODJ6Q46t96mS9ALbeFjRcQ18ypwejY=ug0wCUVv-Q@mail.gmail.com>
 <20140930022751.GA14081@wotan.suse.de> <CAG-2HqUdFWBPUrHg2yezVVu7xedqTQDBxAW5nuYWKWJCTkZSBg@mail.gmail.com>
 <20140930152419.GF14081@wotan.suse.de> <CAG-2HqVBnXUKSRBrJE=gEKA3St5KMfdgAbx2vRfpF3qw_teLOg@mail.gmail.com>
 <20141002200612.GQ14081@wotan.suse.de>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 3 Oct 2014 10:23:24 +0200
Message-ID: <CAG-2HqXxQG0fk2LsBT89fCZMmqo1NqX2xEK1aAT69hY8VLBoQQ@mail.gmail.com>
Subject: Re: [PATCH v1 5/5] driver-core: add driver asynchronous probe support
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Michal Hocko <mhocko@suse.cz>, Greg KH <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Tejun Heo <tj@kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Robert Milasan <rmilasan@suse.com>, werner@suse.com,
        Oleg Nesterov <oleg@redhat.com>, hare <hare@suse.com>,
        Benjamin Poirier <bpoirier@suse.de>,
        Santosh Rastapur <santosh@chelsio.com>, pmladek@suse.cz,
        dbueso@suse.com, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Casey Leedom <leedom@chelsio.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 10:06 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Oct 02, 2014 at 08:12:37AM +0200, Tom Gundersen wrote:
>> Making kmod a special case is of course possible. However, as long as
>> there is no fundamental reason why kmod should get this special
>> treatment, this just looks like a work-around to me.
>
> I've mentioned a series of five reasons why its a bad idea right now to
> sigkill modules [0], we're reviewed them each and still at least
> items 2-4 remain particularly valid fundamental reasons to avoid it

So items 2-4 basically say "there currently are drivers that cannot
deal with sigkill after a three minute timeout".

In the short-term we already have the solution: increase the timeout.
In the long-term, we have two choices, either permanently add some
heuristic to udev to deal with drivers taking a very long time to be
inserted, or fix the drivers not to take such a long time. A priori,
it makes no sense to me that drivers spend unbounded amounts of time
to get inserted, so fixing the drivers seems like the most reasonable
approach to me. That said, I'm of course open to be proven wrong if
there are some drivers that fundamentally _must_ take a long time to
insert (but we should then discuss why that is and how we can best
deal with the situation, rather than adding some hack up-front when we
don't even know if it is needed).

Your patch series should go a long way towards fixing the drivers (and
I imagine there being a lot of low-hanging fruit that can easily be
fixed once your series has landed), and the fact that we have now
increased the udev timeout from 30 to 180 seconds should also greatly
reduce the problem.

Cheers,

Tom
