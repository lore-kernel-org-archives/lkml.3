Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaACNhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:37:51 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:62028 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaACNhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:37:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="87342822"
Message-ID: <52C6BD2B.6090108@citrix.com>
Date: Fri, 3 Jan 2014 13:37:47 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12] Linux Xen PVH support.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <52C598C6.7040902@citrix.com> <20140102190256.GH3021@pegasus.dumpdata.com>
In-Reply-To: <20140102190256.GH3021@pegasus.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/14 19:02, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 02, 2014 at 04:50:14PM +0000, David Vrabel wrote:
>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
>>> The patches, also available at
>>> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v12
>>>
>>> implements the neccessary functionality to boot a PV guest in PVH mode.
>>
>> In general this looks in much better shape now.  Some of the refactoring
>> patches should be queued for 3.14.
> 
> <nods> Thank you for your review!
>>
>> I'm not sure if when the rest wants to go in given that the PVH
>> hypervisor ABI is not yet finalized and is missing support for a number
>> of things with no visible plan for how/when/if this missing
>> functionality will be implemented.
> 
> We could follow the same path that Xen ARM in Linux did.

ARM was a whole new architecture with limited hardware availability
initially so I think what the ARM port did was the right approach.  It's
less clear to me if this is sensible for an existing, widely used
architecture.

If the PVH ABI was fixed and documented then it would be a non-brainer
to merge kernel support even if it was not fully feature complete.

What I don't want is guests or dom0s that used to boot in PVH mode that
would end up not booting at all if Xen is upgraded.  It's probably ok if
PV can be used a fallback.  It's also probably ok if this fallback is a
manual process (e.g., user has to set pvh=0 to get a working guest again).

It would also be preferable for PVH guests to fail hard if run on newer,
incompatible hypervisors.  Whether this is feasible would depend on what
the ABI changes are.

David
