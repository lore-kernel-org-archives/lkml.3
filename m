Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaBGT2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:28:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaBGT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:28:16 -0500
Date: Fri, 7 Feb 2014 11:29:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC/RFT v2 1/8] drivers: base: support cpu cache
 information interface to userspace via sysfs
Message-ID: <20140207192925.GB18771@kroah.com>
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com>
 <1391791763-28518-2-git-send-email-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391791763-28518-2-git-send-email-sudeep.holla@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 04:49:16PM +0000, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> This patch adds initial support for providing processor cache information
> to userspace through sysfs interface. This is based on already existing
> implementations(x86, ia64, s390 and powerpc) and hence the interface is
> intended to be fully compatible.
> 
> The main purpose of this generic support is to avoid further code
> duplication to support new architectures and also to unify all the existing
> different implementations.
> 
> This implementation maintains the hierarchy of cache objects which reflects
> the system's cache topology. Cache objects are instantiated as needed as
> CPUs come online. The cache objects are replicated per-cpu even if they are
> shared. A per-cpu array of cache information maintained is used mainly for
> sysfs-related book keeping.

I thought I asked that you not use "raw" kobjects for this, instead
using 'struct device' or just an attribute group?

Using a kobject means that userspace tools that use libudev have no
chance to see these attributes at all, which is not good, right?

thanks,

greg k-h
