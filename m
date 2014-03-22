Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaCVQZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:25:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaCVQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:25:09 -0400
Date: Sat, 22 Mar 2014 09:26:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3.13 072/149] ACPI / resources: ignore invalid ACPI
 device resources
Message-ID: <20140322162638.GE13385@kroah.com>
References: <20140321000436.377902063@linuxfoundation.org>
 <20140321000439.452672105@linuxfoundation.org>
 <201403220230.49584.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403220230.49584.s.L-H@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 02:30:43AM +0000, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Friday 21 March 2014, Greg Kroah-Hartman wrote:
> > 3.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Zhang Rui <rui.zhang@intel.com>
> > 
> > commit b355cee88e3b1a193f0e9a81db810f6f83ad728b upstream.
> > 
> > ACPI table may export resource entry with 0 length.
> > But the current code interprets this kind of resource in a wrong way.
> > It will create a resource structure with
> > res->end = acpi_resource->start + acpi_resource->len - 1;
> > 
> > This patch fixes a problem on my machine that a platform device fails
> > to be created because one of its ACPI IO resource entry (start = 0,
> > end = 0, length = 0) is translated into a generic resource with
> > start = 0, end = 0xffffffff.
> > 
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [...]
> 
> This patch should probably be dropped from -stable (3.13 and 3.10) for 
> the time being, it causes this warning:
> 
> pnp 00:01: unknown resource type 4 in _CRS
> pnp 00:01: can't evaluate _CRS: 1
> 
> on all systems I've tested it on so far (~12 systems of vastly varying 
> components and age, covering amd64 and i386).
> 
> This also seems to affect others as well:
> 	http://www.spinics.net/lists/linux-acpi/msg49431.html
> 	http://www.spinics.net/lists/linux-acpi/msg49438.html

Is this also a problem in Linus's tree?  If so, shouldn't a fix go there
first?

greg k-h
