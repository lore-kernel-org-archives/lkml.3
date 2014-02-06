Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbaBFNO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:14:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53384 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756397AbaBFNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:14:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 0/6] PM / QoS: Introduce latency tolerance device PM QoS type
Date: Thu, 06 Feb 2014 14:22:10 +0100
Message-ID: <1550670.IB7tE3uSq4@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1447517.8AFrWcAgld@vostro.rjw.lan>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan> <1447517.8AFrWcAgld@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 23, 2014 02:34:59 PM Rafael J. Wysocki wrote:
> On Friday, January 17, 2014 03:42:13 PM Rafael J. Wysocki wrote:
> > Hi All,
> > 
> > On some platforms hardware may switch to an energy-saving mode on the fly
> > on the basis of certain utilization metrics used by it.  That usually is
> > desirable from the energy conservation standpoint, but it generally causes
> > latencies to increase which may adversely affect some operations.  For this
> > reason, the platforms in question usually provide some interfaces for software
> > to indicate its latency tolerance and possibly to prevent the energy-saving
> > modes from being selected too aggressively.
> > 
> > The following series of patches introduces a device PM QoS type allowing
> > those interfaces to be used by kernel code and user space.  It is designed
> > in analogy with the existing resume latency device PM QoS type, which allows
> > some pieces of the existing device PM QoS code to be re-used and makes the
> > new user space interface fit into the existing framework.
> > 
> > Patch [1/5] modifies the names of symbols, variables, functions and structure
> > fields associated with the existing resume latency device PM QoS type to
> > avoid any confusion with the new one introduced by the subsequent patches.
> > 
> > Patch [2/5] introduces a new field in struct pm_qos_constraints for specifying
> > a special value to be returned as the effective requirement when the given list
> > of PM QoS requirements is empty.  That field is necessary for the new latency
> > tolerance device PM QoS type.
> > 
> > Patch [3/5] introduces the latency tolerance device PM QoS type along with
> > documentation.
> > 
> > Patch [4/5] modifies the ACPI LPSS (Low-Power Subsystem) driver to hook up
> > LPSS devices to the new latency tolerance device PM QoS interface.
> > 
> > Patch [5/5] modifies the dev_pm_qos_add_ancestor_request() routine so that it
> > can be used by drivers of devices without hardware latency tolerance support
> > for specifying their requirements via the ancestors of those devies.
> 
> As usual, testing uncovered some issues, so an updated series follows.

OK, no comments - no objections.  Cool! :-)

Time for a non-RFC submission I guess.

The following series is almost the same as the previous one except for patch
[5/6] that fixes a bug (LPSS_LTR_SNOOP_REQ has to be set along with
LPSS_LTR_SNOOP_LAT_1US) and introduces a cutoff value such that all above it
will mean "no requirement".

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
