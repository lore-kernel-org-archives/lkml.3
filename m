Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaKIAIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 19:08:04 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39358 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaKIAIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 19:08:01 -0500
Date: Sun, 9 Nov 2014 01:07:57 +0100
From: Karol Lewandowski <lmctlx@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, pmoore@redhat.com,
        jkosina@suse.cz, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org, arnd@arndb.de,
        tj@kernel.org, desrt@desrt.ca, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, dh.herrmann@gmail.com, casey.schaufler@intel.com,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk,
        linux-security-module@vger.kernel.org, r.krypa@samsung.com
Subject: Re: [RFC PATCH 0/5] kdbus: add support for lsm
Message-ID: <20141109000757.GA23762@pix>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
 <20141107180120.GA15387@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107180120.GA15387@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:01:20AM -0800, Greg KH wrote:
> On Fri, Oct 31, 2014 at 05:36:32PM +0100, Karol Lewandowski wrote:
> > This is set of EXPERIMENTAL patches adding lsm support to kdbus.
> > (Rebased on top of v3.17.)
> > 
> > >From least to most invasive:
> > 
> >  - (1) kdbus: extend structures with security pointer for lsm
> > 
> >    Trivial.  Applicable as-is.
> > 
> >  - (2) security: export security_file_receive for modules
> >    (3) kdbus: check if lsm permits installing received fds
> > 
> >    fd_install doesn't seem to consult LSM, these patches
> >    ensure that receiving process has the right to sent fds. 
> > 
> >    Compile-tested only.
> > 
> >  - (4) security: introduce lsm hooks for kdbus
> >    (5) kdbus: make use of new lsm hooks
> > 
> >    Set of proof-of-concept hooks discussed previously with Paul Moore.
> > 
> >    kdbus integration patch (5) for review, but unlikely for integration
> >    at this stage.
> > 
> >    Likewise, compile-tested only.
> > 
> > 
> > Karol Lewandowski (5):
> >   kdbus: extend structures with security pointer for lsm
> >   security: export security_file_receive for modules
> >   kdbus: check if lsm permits installing received fds
> >   security: introduce lsm hooks for kdbus
> >   kdbus: make use of new lsm hooks
> 
> These looks reasonable to me, thanks for sending them.  They will need
> to be refreshed again after this next round of changes, but it shouldn't
> be that hard to do so.

Sure thing.

For completness - there are accompanying Smack and SELinux patches that
could go together with above patches, ie.

  https://github.com/lmctl/linux/commit/103c26fd27d1ec8c32d85dd3d85681f936ac66fb

  http://git.infradead.org/users/pcmoore/selinux/commitdiff/eef4844f91fef6092b6bfac941ebe7f18375be9d

I've got some free time on my hands now, so I'll try to revisit these too.

Cheers,
Karol Lewandowski
