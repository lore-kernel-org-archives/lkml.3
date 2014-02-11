Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBKAMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:12:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaBKAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:11:56 -0500
Date: Mon, 10 Feb 2014 16:13:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v2 1/8] drivers: base: support cpu cache
 information interface to userspace via sysfs
Message-ID: <20140211001310.GB3692@kroah.com>
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com>
 <1391791763-28518-2-git-send-email-sudeep.holla@arm.com>
 <20140207192925.GB18771@kroah.com>
 <52F915F6.9000501@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F915F6.9000501@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:09:58PM +0000, Sudeep Holla wrote:
> On 07/02/14 19:29, Greg Kroah-Hartman wrote:
> > On Fri, Feb 07, 2014 at 04:49:16PM +0000, Sudeep Holla wrote:
> >> From: Sudeep Holla <sudeep.holla@arm.com>
> >>
> >> This patch adds initial support for providing processor cache information
> >> to userspace through sysfs interface. This is based on already existing
> >> implementations(x86, ia64, s390 and powerpc) and hence the interface is
> >> intended to be fully compatible.
> >>
> >> The main purpose of this generic support is to avoid further code
> >> duplication to support new architectures and also to unify all the existing
> >> different implementations.
> >>
> >> This implementation maintains the hierarchy of cache objects which reflects
> >> the system's cache topology. Cache objects are instantiated as needed as
> >> CPUs come online. The cache objects are replicated per-cpu even if they are
> >> shared. A per-cpu array of cache information maintained is used mainly for
> >> sysfs-related book keeping.
> > 
> > I thought I asked that you not use "raw" kobjects for this, instead
> > using 'struct device' or just an attribute group?
> > 
> 
> Correct, sorry I should have mentioned here instead of cover letter that it's
> not yet done. Since the changes involved other architectures, I posted v2 to get
> early feedback and testing. More over it's one place to fix now instead of 4
> unlike before.

Ok, I'll wait to review it after you do the device conversion.

> Just adding cache as a device as you suggested won't suffice here. As we need to
> track multiple cache indices for each cpu, devices are needed for each cache
> index. I tried using device_create_with_groups which provides all we need in one
> api for cache indices but since cpu devices are not associated with any class,
> it fails if class is NULL. Any suggestions ?

Make the cpu devices be part of a class?

thanks,

greg k-h
