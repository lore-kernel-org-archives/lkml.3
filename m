Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162625Ab3DEVGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:06:52 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60850 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162376Ab3DEVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:06:51 -0400
Date: Fri, 5 Apr 2013 14:06:48 -0700
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
Subject: Re: [PATCH v2] Introduce Intel RAPL cooling device driver
Message-ID: <20130405210648.GB18505@kroah.com>
References: <1365195724-8945-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365195724-8945-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 02:02:04PM -0700, Jacob Pan wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions. Since its first appearance on Sandy Bridge, more
> features have being added to extend its usage. In RAPL, platforms are
> divided into domains for fine grained control. These domains include
> package, DRAM controller, CPU core (Power Plane 0), graphics uncore
> (power plane 1), etc.
> 
> The purpose of this driver is to expose RAPL for userspace
> consumption. Overall, RAPL fits in the generic thermal layer in
> that platform level power capping and monitoring are mainly used for
> thermal management and thermal layer provides the abstracted interface
> needed to have portable applications.
> 
> Specifically, userspace is presented with per domain cooling device
> with sysfs links to its true device. Although RAPL domain provides many
> parameters for fine tuning, long term power limit is exposed as the
> single knob via cooling device state. Whereas the rest of the
> parameters are still accessible via the linked RAPL class devices.
> This interface allows both simple and advanced use cases.
> 
> Eventfd is used to provide notifications to the userspace. At per domain
> level, use can choose any event capable parameters to register for
> threshold crossing notifications. This is shamelessly "borrowed" from
> cgroup with some trimming/fitting.
> 
> Zhang, Rui's initial RAPL driver was used as a reference and starting
> point. Many thanks.
> https://lkml.org/lkml/2011/5/26/93
> 
> Unlike the patch above, which is mainly for monitoring, this driver
> focus on the control and usability by user applications.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

As described in the cover letter response:
	NACKed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

please redo this based on those comments.

greg k-h
