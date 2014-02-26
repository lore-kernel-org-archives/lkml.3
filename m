Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaBZIFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:05:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaBZIFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:05:09 -0500
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
From: Alexander Graf <agraf@suse.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
Date: Wed, 26 Feb 2014 15:49:20 +0800
Message-Id: <33B27E4E-11A7-45FD-B708-C2B380AB6608@suse.de>
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <20140225171528.GJ4407@cmpxchg.org> <alpine.LSU.2.11.1402251652230.979@eggly.anvils>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <alpine.LSU.2.11.1402251652230.979@eggly.anvils>
To: Hugh Dickins <hughd@google.com>
X-Mailer: iPhone Mail (11B554a)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Am 26.02.2014 um 09:05 schrieb Hugh Dickins <hughd@google.com>:
> 
>> On Tue, 25 Feb 2014, Johannes Weiner wrote:
>>> On Tue, Feb 25, 2014 at 12:28:04AM +0100, Alexander Graf wrote:
>>> Configuration of tunables and Linux virtual memory settings has traditionally
>>> happened via sysctl. Thanks to that there are well established ways to make
>>> sysctl configuration bits persistent (sysctl.conf).
>>> 
>>> KSM introduced a sysfs based configuration path which is not covered by user
>>> space persistent configuration frameworks.
>>> 
>>> In order to make life easy for sysadmins, this patch adds all access to all
>>> KSM tunables via sysctl as well. That way sysctl.conf works for KSM as well,
>>> giving us a streamlined way to make KSM configuration persistent.
>> 
>> ksm can be a module, so this won't work.
> 
> That's news to me.  Are you writing of some Red Hat patches, or just
> misled by the "module_init(ksm_init)" which used the last line of ksm.c?

Ugh, sorry. I should have double-checked this. KSM is bool in Kconfig and so is THP.

> 
> I don't mind Alex's patch, but I do think the same should be done for
> THP as for KSM, and a general

I agree.

> solution more attractive than more #ifdefs
> one by one.  Should a general

I don't see a good alternative to this.

> solution just be in userspace, in sysctl(8)?

User space needs to have the ability to list available sysctls, so we need to have an enumerable map between sys and sysctl somewhere. Keeping that list close to where the actual files are implemented seems to make sense to me, as it's very hard to miss out on addition and removal of parameters throughout the stack this way. That's why I put it here.


Alex

