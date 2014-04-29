Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbaD2Iin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:38:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33120 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932941AbaD2Iik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:38:40 -0400
Date: Tue, 29 Apr 2014 09:38:32 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] rcutorture: don't mark torture_init_{begin,end} with
 __init
Message-ID: <20140429083831.GA26067@arm.com>
References: <1398711815-22153-1-git-send-email-will.deacon@arm.com>
 <20140428201304.GI4430@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428201304.GI4430@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 09:13:04PM +0100, Paul E. McKenney wrote:
> On Mon, Apr 28, 2014 at 08:03:35PM +0100, Will Deacon wrote:
> > By the time rcutorture is initialised via its module_init callback, the
> > .init.text section of torture.ko has already been freed, so the calls to
> > torture_init{begin,end} end up branching to junk.
> > 
> > This patch removes the __init annotations from torture_init_{begin,end}
> > to make sure the code is there when we want to call it.
> > 
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Good catch, and apologies for the wasted day, but someone beat you to
> this.  By only 12 days, which is a bit surprising given how long this
> has been lurking.

Oh well, at least it's getting fixed!

Will
