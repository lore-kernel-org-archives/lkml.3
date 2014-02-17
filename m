Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaBQF0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:26:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53678 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBQF0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:26:51 -0500
Message-ID: <1392614801.5565.92.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Mon, 17 Feb 2014 06:26:41 +0100
In-Reply-To: <20140212182336.GD5496@localhost.localdomain>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	 <52F8A51F.4090909@cn.fujitsu.com>
	 <20140210184729.GL4250@linux.vnet.ibm.com>
	 <20140212182336.GD5496@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:iRxeAjM5uVXxz+e/QZN80nLDzNPM6oc7xl4V6ytaO3x
 6RlhgM1iwIVzM7VPSFcjYQnUKTliTUEfaP5GVfXOKwVMjXq95C
 LsMIhRYk/sFwx1Wj8diXJVDaOeGSGOZT8paN/i/eMtC8qqVcdE
 CXoiLGg4TTKGnNcJF5+z3er1mtDSfJJ5L3/ODNd4BOYbJzVWIO
 0bGt/Cqx4h83+WIXZZmc5hY0w+oITaGTBJTjpfty3GdgOdk0Q2
 HX/bBMRzS4qOU/bTKpSA0RMJiNjDAXIWacfrrcVrNb4cp978lh
 CR5UpIHG2UJiXK9YCN4qIvnQqz+N7Lp08+phyCb5pzu7DKTSeb
 AFKy5+RvKH7loGNPwZcIxIAZ38W+mtuYFoLXI4S/IVeR6L0rJy
 wYxtCcDm+35Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 19:23 +0100, Frederic Weisbecker wrote: 
> On Mon, Feb 10, 2014 at 10:47:29AM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 10, 2014 at 06:08:31PM +0800, Lai Jiangshan wrote:
> > > Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Thank you all, queued for 3.15.
> > 
> > We should also have some facility for moving the SRCU workqueues to
> > housekeeping/timekeeping kthreads in the NO_HZ_FULL case.  Or does
> > this patch already have that effect?
> 
> Kevin Hilman and me plan to try to bring a new Kconfig option that could let
> us control the unbound workqueues affinity through sysfs.

Handing control to the user seemed like a fine thing, so I started
making a boot option to enable it.  Forcing WQ_SYSFS on at sysfs
decision spot doesn't go well, init order matters :)  Post init frobbing
required if you want to see/frob all unbound.

-Mike

