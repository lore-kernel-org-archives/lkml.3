Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbaISPqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbaISPqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:46:21 -0400
Date: Fri, 19 Sep 2014 16:44:23 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, bmr@redhat.com, jcastillo@redhat.com,
        mguzik@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] fs: Use a seperate wq for do_sync_work() to avoid a
 potential deadlock
Message-ID: <20140919154423.GH25400@atomlin.usersys.redhat.com>
References: <1410953942-32144-1-git-send-email-atomlin@redhat.com>
 <20140917182202.GE19308@redhat.com>
 <20140917204634.GB25400@atomlin.usersys.redhat.com>
 <20140917211613.GU4322@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140917211613.GU4322@dastard>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 07:16:13AM +1000, Dave Chinner wrote:
> >   - Both lru_add_drain and do_sync_work work items are added to
> >     the same global system_wq
> > 
> >   - The current work fn on the system_wq is do_sync_work and is
> >     blocked waiting to aquire an sb's s_umount for reading
> > 
> >   - The umount task is the current owner of the s_umount in
> >     question but is waiting for do_sync_work to continue.
> >     Thus we hit a deadlock situation.
> 
> What kernel did you see this deadlock on?

Sorry for the noise. This deadlock was produced under a kernel whereby
the workqueue implementation is significantly less sophisticated.

-- 
Aaron Tomlin
