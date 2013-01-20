Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab3ATHkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 02:40:41 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:61159 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3ATHkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 02:40:39 -0500
Date: Sat, 19 Jan 2013 23:40:24 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: iwlwifi: regression in 3.8-rc4 and 3.7.3
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301920DA0@HASMSX103.ger.corp.intel.com>
Message-ID: <alpine.LNX.2.00.1301192331140.3905@eggly.anvils>
References: <alpine.LNX.2.00.1301192141540.1303@eggly.anvils> <CA+icZUWULf9-3vEQHM59HM7+PPXxvpWGnNB137+=WyEXj9noiQ@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301920DA0@HASMSX103.ger.corp.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jan 2013, Grumbach, Emmanuel wrote:
> > 
> > On Sun, Jan 20, 2013 at 6:56 AM, Hugh Dickins <hughd@google.com> wrote:
> > > After sending the first 2MB, scp over wireless becomes unbearably
> > > slow, with frequent stalls: on this ThinkPad T420s running 3.8-rc4 or 3.7.3.
> > > Not always, but often.
> > >
> > 
> > There is one pending iwlwifi-fixes, dunno if it will fix your issue.
> > [1] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-
> > fixes.git;a=commitdiff;h=c3e5d7181afb66657393066bccce0956fab09ab3
> 
> Right - so the 2 patches are unrelated, and the one Sedat is pointing at is relevant for 3.8 only. It fixes a bug that has been introduced in 3.8.

Yes, I have now given that one a try, but it does not affect my issue.

> Regarding the issue Hugh is suffering from, I have to say that I am a little confused since I am pretty sure the patch is right. Now, it might uncover other pre-existing bugs. All I can say is that I don't think that reverting the patch is *so* problematic since the patch really wants to solve a rare case. If it causes issues, we can simply revert it. It only means that when I will get a little bit of time, I might need to ask you a few logs. Thanks for the report (and the bisection).

Sure, let me know what to do, once you have time to investigate.

So far as I know, I'm the first to notice: so we can probably
leave it in 3.8-rc for now, until/unless it gives wider trouble.

But reverting from 3.7-stable soon would be a good idea,
regressions there being more tiresome.

Hugh
