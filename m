Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbaLPBrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:47:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:34815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaLPBrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:47:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429401377"
Message-ID: <1418694459.5745.198.camel@intel.com>
Subject: Re: [LKP] [userns] BUG: unable to handle kernel NULL pointer
 dereference at (null)
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Date: Tue, 16 Dec 2014 09:47:39 +0800
In-Reply-To: <87iohcx1k1.fsf@x220.int.ebiederm.org>
References: <1418613661.5745.164.camel@intel.com>
	 <87iohcx1k1.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-15 at 11:31 -0600, Eric W. Biederman wrote:
> Huang Ying <ying.huang@intel.com> writes:
> 
> > FYI, we noticed the below changes on
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> > commit bbea5f5532501fdd67f46442ba7b1122d7ff3123 
> > ("userns: Add a knob to disable setgroups on a per user namespace basis")
> 
> Thank you.
> 
> I am quite puzzled by this failure.  There was an similar failure when
> /proc/[pid]/setgroups was read (if I recall correctly).  I don't see how
> that change could result at failures during open or failures during
> boot.  I added a new file to proc which any reasonable system should
> leave alone.  Are you by chance running trinity during boot?

Yes.  We are running trinity during boot.

> If the reproducer gave me any clue about which file that was opened or
> which code path this happened on I would be bery interested.  If for no
> other reason that to confirm that I have fixed the issue.

This is just boot test, with trinity running after kernel boot.

Fengguang, do you have more information?

Best Regards,
Huang, Ying

> I have rewritten the implementation of /proc/[pid]/setgroups so it is
> simpler and more robust and does not have any errors I can detect.
> 
> Thank you very much for picking up my for-testing branch and beating up
> on it.
> 
> Eric


