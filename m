Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbaGRPFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:05:38 -0400
Received: from gw1.transmode.se ([195.58.98.146]:60128 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaGRPFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:05:37 -0400
In-Reply-To: <OF542E7A59.842197B0-ONC1257D19.004B7FF4-C1257D19.004BEC7C@LocalDomain>
References: <OF6F10655B.C9BFC08D-ONC1257D18.003D22DF-C1257D18.003E2204@transmode.se> <CAFLxGvw6W196E4mcefz_b16iGHSFKF=RP1gx5eLj0U5NSR9SXg@mail.gmail.com> <OF542E7A59.842197B0-ONC1257D19.004B7FF4-C1257D19.004BEC7C@LocalDomain>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: ls -l /proc/1/exe -> Permission denied
X-KeepSent: 94BC7D2A:31F0FF60-C1257D19:00528EC9;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF94BC7D2A.31F0FF60-ONC1257D19.00528EC9-C1257D19.0052E7FB@transmode.se>
Date: Fri, 18 Jul 2014 17:05:32 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 18/07/2014 17:05:32,
	Serialize complete at 18/07/2014 17:05:32
Content-Type: text/plain; charset="US-ASCII"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joakim Tjernlund/Transmode wrote on 2014/07/18 15:49:17:
> 
> Richard Weinberger <richard.weinberger@gmail.com> wrote on 2014/07/18 
14:58:30:
> > 
> > On Thu, Jul 17, 2014 at 1:18 PM, Joakim Tjernlund
> > <joakim.tjernlund@transmode.se> wrote:
> > > Trying to real /proc/<pid>/exe I noticed I could not read links not
> > > belonging to my user such as:
> > > jocke >  ls -l /proc/1/exe
> > >              ls: cannot read symbolic link /proc/1/exe: Permission 
denied
> > >
> > > Is this expected?
> > 
> > Why do you think this is unexpected?

> It only shows the full path to the executable, compare with comm which 
shows basename(app).
> 
> I have an idea for qemu-user which needs to identify which processes
> are running /usr/bin/qemu-<arch> and which are not so it knows how
> to munge different /proc/ files.

Just to be clear, I expect to read where /proc/1/exe points, not the 
contents of the file
pointed to.

It seems that any and all symlinks are forbidden:
> ls -l /proc/1
ls: cannot read symbolic link /proc/1/cwd: Permission denied
ls: cannot read symbolic link /proc/1/root: Permission denied
ls: cannot read symbolic link /proc/1/exe: Permission denied

 Jocke
