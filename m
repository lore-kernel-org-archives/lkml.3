Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaAXMfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:35:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:38144 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaAXMf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:35:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,712,1384329600"; 
   d="scan'208";a="464102097"
Date: Fri, 24 Jan 2014 20:35:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [mac80211] BUG: unable to handle kernel paging request at
 6b6b6b8f
Message-ID: <20140124123526.GA28678@localhost>
References: <20140124120840.GA25638@localhost>
 <1390565870.4257.40.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390565870.4257.40.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:17:50PM +0100, Johannes Berg wrote:
> On Fri, 2014-01-24 at 20:08 +0800, Fengguang Wu wrote:
> > Hi Johannes,
> > 
> > The BUG does not show up in linux-next 20140124, is it fixed now?
> 
> It isn't in linux-next yet I believe (mac80211-next isn't in there), but
> yeah, I fixed it already, ran into it myself yesterday. Hope it didn't
> cause you too much trouble.

That's great, you are quick hand! It's not problem at all for me. :)

Thanks,
Fengguang

> The problem was that I misplaced some code
> because I didn't notice that the if () condition (see below) had no
> braces.
> 
> I replaced that commit with
> commit 091a69f86862454c282d4a64c9d66074e60514ea
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Jan 22 10:36:59 2014 +0100
> 
>     mac80211: remove module handling from rate control ops
> 
> which now contains this change
> 
>         list_for_each_entry(alg, &rate_ctrl_algs, list) {
> -               if (!strcmp(alg->ops->name, name))
> -                       if (try_module_get(alg->ops->module)) {
> -                               ops = alg->ops;
> -                               break;
> -                       }
> +               if (!strcmp(alg->ops->name, name)) {
> +                       ops = alg->ops;
> +                       break;
> +               }
>         }
> 
> (note the new set of braces added around the content of the strcmp if)
> 
> Sorry!
> 
> johannes
> 
