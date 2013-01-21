Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3AUKhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:37:22 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:32394 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509Ab3AUKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:37:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,505,1355094000"; 
   d="scan'208";a="190888617"
Date: Mon, 21 Jan 2013 11:37:13 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Namjae Jeon <linkinjeon@gmail.com>
cc: jaegeuk.kim@samsung.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] f2fs: use _safe() version of list_for_each
In-Reply-To: <CAKYAXd-H0KHMavYRk3PEshXNtN_ke5rH_qa-8XTT6RWZXYmFcw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1301211135300.1930@hadrien>
References: <20130120150258.GB32551@elgon.mountain> <20130121083245.GA11592@core.coreip.homeip.net> <1358760001.8234.150.camel@kjgkr> <CAKYAXd-H0KHMavYRk3PEshXNtN_ke5rH_qa-8XTT6RWZXYmFcw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2084525288-1358764633=:1930"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2084525288-1358764633=:1930
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 21 Jan 2013, Namjae Jeon wrote:

> 2013/1/21, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> > 2013-01-21 (월), 00:32 -0800, Dmitry Torokhov:
> >> On Sun, Jan 20, 2013 at 06:02:58PM +0300, Dan Carpenter wrote:
> >> > This is calling list_del() inside a loop which is a problem when we try
> >> > move to the next item on the list.  I've converted it to use the _safe
> >> > version.  And also, as a cleanup, I've converted it to use
> >> > list_for_each_entry instead of list_for_each.
> >> >
> >> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >> > ---
> >> > Static analysis stuff.  Untested.  Please review carefully.
> >>
> >> Makes sense to me.
> >>
> >> Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> >>
> >
> > No doubt, applied.
> > Thanks,
> I agree in cases – where we will have chances of parallel access and
> modification to the linked we should use list_for_each_entry_safe()
> But my point was related with this code change case in the patch.
> We will have path like this:
> f2fs_fill_super->recover_fsync_data->destroy_fsync_dnodes()
> From this calling path – there can only be a single caller at any
> given time. So, we will not have the case of having parallel access to
> the list which is local to recover_fsync_data() and destroyed on exit
> from this function.
> From the real issue point of view – this does not looks convincing to
> me why expensive _safe fucntion should used.

The need for the safe version has nothing to do with parallelism.  It has
to do with whether the loop deletes some of the elements in the list.
The non-safe list mechanism uses the current element to get to the next
element.  If the current element has been deleted, it cannot get to the
next one.

julia
--8323329-2084525288-1358764633=:1930--
