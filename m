Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbaJ2OOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:14:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:3723 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932927AbaJ2OOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,810,1406617200"; 
   d="scan'208";a="613443230"
Date: Wed, 29 Oct 2014 22:14:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Junjie Mao <eternal.n08@gmail.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mac80211_hwsim: release driver when
 ieee80211_register_hw fails
Message-ID: <20141029141408.GA9436@wfg-t540p.sh.intel.com>
References: <1414459907-7509-1-git-send-email-eternal.n08@gmail.com>
 <20141029064501.GB2985@piware.de>
 <8638a718ft.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8638a718ft.fsf@MJJ-LAPTOP.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 06:23:02PM +0800, Junjie Mao wrote:
> I was not familiar with the acquiring/releasing API either, until I met
> with this bug...
> 
> Perhaps we can use static checkers to avoid these issues as early as
> possible. Any suggestions?

CC Dan. His smatch checker might be able (or could be enabled) to
handle the verification of missing device_release_driver() call.

Thanks,
Fengguang

> Martin Pitt <martin.pitt@ubuntu.com> writes:
> 
> > Acked-By: Martin Pitt <martin.pitt@ubuntu.com>
> >
> > Hello Junjie,
> >
> > Junjie Mao [2014-10-28  9:31 +0800]:
> >> The driver is not released when ieee80211_register_hw fails in
> >> mac80211_hwsim_create_radio, leading to the access to the unregistered (and
> >> possibly freed) device in platform_driver_unregister:
> >
> > Many thanks for fixing this! Sorry about that, I don't know these bits
> > very well.
> >
> > Martin
