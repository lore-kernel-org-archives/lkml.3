Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaBDQ4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:56:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaBDQ4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:56:36 -0500
Date: Tue, 4 Feb 2014 08:57:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 2/4] staging/lustre/obdclass: read jobid from proc
Message-ID: <20140204165742.GA19660@kroah.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
 <1383132636-8952-2-git-send-email-bergwolf@gmail.com>
 <20131030132101.GD30087@kroah.com>
 <20140204061210.GA944142@fiona.linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204061210.GA944142@fiona.linuxhacker.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 10:12:10AM +0400, Oleg Drokin wrote:
> Hello!
> 
> On Wed, Oct 30, 2013 at 06:21:01AM -0700, Greg Kroah-Hartman wrote:
> > > - * stored in between the "env_start" & "env_end" of task struct.
> > > +static char *self_environ_file = "/proc/self/environ";
> > 
> > Heh, no, that's not ok at all.
> > 
> > This is a _huge_ sign that you are doing something wrong in your driver
> > if you need something that isn't exported, or that you have to dig out
> > of proc.
> > 
> > Sorry, I can't take this, please fix the underlying problems that would
> > even think that you need access to the environment from within a kernel
> > driver.
> 
> I took a stab at this.
> This is not a final patch, I know there's still some number of checkpatch
> warnings and the proc layout is not finalized yet for example.
> 
> But before I spend any more time in polishing this, can you please take a look
> and advise if this direction would be acceptable for you when driven to
> completion?

What exactly are you doing here?  Calling out to userspace for what
information?  And how are you going to handle namespaces and containers
by doing that?  Are you going to block in the kernel for this
information?

What are you trying to solve with this code in the first place?

greg k-h
