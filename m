Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaBZBG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:06:27 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37721 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaBZBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:06:26 -0500
Date: Tue, 25 Feb 2014 17:05:34 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Alexander Graf <agraf@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
In-Reply-To: <20140225171528.GJ4407@cmpxchg.org>
Message-ID: <alpine.LSU.2.11.1402251652230.979@eggly.anvils>
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <20140225171528.GJ4407@cmpxchg.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Johannes Weiner wrote:
> On Tue, Feb 25, 2014 at 12:28:04AM +0100, Alexander Graf wrote:
> > Configuration of tunables and Linux virtual memory settings has traditionally
> > happened via sysctl. Thanks to that there are well established ways to make
> > sysctl configuration bits persistent (sysctl.conf).
> > 
> > KSM introduced a sysfs based configuration path which is not covered by user
> > space persistent configuration frameworks.
> > 
> > In order to make life easy for sysadmins, this patch adds all access to all
> > KSM tunables via sysctl as well. That way sysctl.conf works for KSM as well,
> > giving us a streamlined way to make KSM configuration persistent.
> 
> ksm can be a module, so this won't work.

That's news to me.  Are you writing of some Red Hat patches, or just
misled by the "module_init(ksm_init)" which used the last line of ksm.c?

I don't mind Alex's patch, but I do think the same should be done for
THP as for KSM, and a general solution more attractive than more #ifdefs
one by one.  Should a general solution just be in userspace, in sysctl(8)?

Hugh
