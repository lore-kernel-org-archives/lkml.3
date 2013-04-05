Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162409Ab3DEVGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:06:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46938 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162241Ab3DEVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:06:09 -0400
Date: Fri, 5 Apr 2013 14:06:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Joe Perches <joe@perches.com>, Randy Dunlap <rdunlap@infradead.org>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2] RAPL (Running Average Power Limit) driver
Message-ID: <20130405210605.GA18505@kroah.com>
References: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 02:02:03PM -0700, Jacob Pan wrote:
> Changes since V2:
> 	- use 'struct device' instead of raw kobject to represent
> 	  RAPL domains
> 	- changed eventfd control interface to use event string
> 	  instead of passing file descriptors that cannot be
> 	  authenticated in sysfs directory
> 	- clean ups based on v1 reviews
> 		- use kcalloc for arrays
> 		- drop dependencies on X86
> 		- misc cleanups

Please no, split this up into at least 2 patches, the first being the
"standard" thermal driver, and the rest for the "custom" extensions you
are proposing.

That way the first can get accepted easily, and into 3.10 (hopefully),
so people can use it and not stall everything as we continue to iterate
over the "custom" things.

As is, this driver isn't acceptable, sorry.

greg k-h
