Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482AbaJ3OsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:48:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210AbaJ3OsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:48:20 -0400
Date: Thu, 30 Oct 2014 07:47:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141030144709.GA19721@kroah.com>
References: <54520A21.20404@samsung.com>
 <54521697.1030900@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54521697.1030900@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 11:44:39AM +0100, Karol Lewandowski wrote:
> [ Sorry for breaking thread and resend - gmane rejected my original message
>   due to too long list of recipients... ]
> 
> On 2014-10-30 00:40, Greg Kroah-Hartman wrote:
> 
> > There is a 1815 line documentation file in this series, so we aren't
> > trying to not provide this type of information here at all.  But yes,
> > more background, about why this can't be done in userspace (zero copy,
> > less context switches, proper credential passing, timestamping, availble
> > at early-boot, LSM hooks for security models to tie into
> 
> While you're at it... I did some work on proof-of-concept LSM patches for
> kdbus some time ago, see [1][2].  Currently, these are completely of date.
> 
>  [1] https://github.com/lmctl/linux/commits/kdbus-lsm-v4.for-systemd-v212
>  [2] https://github.com/lmctl/kdbus/commit/aa0885489d19be92fa41c6f0a71df28763228a40
> 
> May I ask if you guys have your own plan for LSM or maybe it would be
> worth to resurrect [1]?

The core calls are already mediated by LSM today, right?  We don't want
anyone to be parsing the data stream through an LSM, that idea got
rejected a long time ago as something that is really not a good idea.

Other than that, I don't know exactly what your patches do, or why they
are needed, care to go into details?

thanks,

greg k-h
