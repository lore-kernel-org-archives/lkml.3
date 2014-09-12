Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaILS3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:29:54 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:33217 "EHLO
	homiemail-a99.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbaILS3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:29:52 -0400
Message-ID: <1410546516.12906.9.camel@linux-t7sj.site>
Subject: Re: [PATCH 6/9] torture: Address race in module cleanup
From: Davidlohr Bueso <dave@stgolabs.net>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 12 Sep 2014 11:28:36 -0700
In-Reply-To: <20140912180407.GF4775@linux.vnet.ibm.com>
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
	 <1410493224-3312-7-git-send-email-dave@stgolabs.net>
	 <20140912180407.GF4775@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 11:04 -0700, Paul E. McKenney wrote:
> On Thu, Sep 11, 2014 at 08:40:21PM -0700, Davidlohr Bueso wrote:
> > When performing module cleanups by calling torture_cleanup() the
> > 'torture_type' string in nullified However, callers are not necessarily
> > done, and might still need to reference the variable. This impacts
> > both rcutorture and locktorture, causing printing things like:
> > 
> > [   94.226618] (null)-torture: Stopping lock_torture_writer task
> > [   94.226624] (null)-torture: Stopping lock_torture_stats task
> > 
> > Thus delay this operation until the very end of the cleanup process.
> > The consequence (which shouldn't matter for this kid of program) is,
> > of course, that we delay the window between rmmod and modprobing,
> > for instance in module_torture_begin().
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> 
> Good catch!  I had just been ignoring the (null), and my scripting
> doesn't care, but it is better to have it taken care of.

In addition, for locktorture this issue can cause not only null but the
printing the wrong cleanup string when a new module is loaded with a
different torture_type.

Thanks,
Davidlohr

