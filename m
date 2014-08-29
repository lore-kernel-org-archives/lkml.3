Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaH2CnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:43:14 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48978 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaH2CnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:43:13 -0400
Message-ID: <53FFE87B.9040802@cs.wisc.edu>
Date: Thu, 28 Aug 2014 21:42:03 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>
CC: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
References: <1408244954-27417-1-git-send-email-kys@microsoft.com> <1408244988-27456-1-git-send-email-kys@microsoft.com> <1408244988-27456-2-git-send-email-kys@microsoft.com> <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de>
In-Reply-To: <53FDEBB9.5070704@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 09:31 AM, Hannes Reinecke wrote:
> On 08/19/2014 07:54 PM, Christoph Hellwig wrote:
>> On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
>>> The host asks the guest to scan when a LUN is removed or added.
>>> The only way a guest can identify the removed LUN is when an I/O is
>>> attempted on a removed LUN - the SRB status code indicates that the LUN
>>> is invalid. We currently handle this SRB status and remove the device.
>>>
>>> Rather than waiting for an I/O to remove the device, force the
>>> discovery of
>>> LUNs that may have been removed prior to discovering LUNs that may have
>>> been added.
>>
>> This looks pretty reasonable to me, but I wonder if we should move this
>> up to common code so that it happens for any host rescan triggered by
>> sysfs or other drivers as well.
>>
> Not without proper testing.
> Currently we cannot rescan existing devices; the inquiry string is
> nailed to the sdev structure. The only way to really refresh the
> information is to delete it and rescan it again.

How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
gets passed to userspace? Is everyone kicking off a new full (add and
delete) scan to handle this or logging it? Is the driver returning this
when the LUNs change?

Also is the driver getting a 0x5/0x25/0 (invalid LUN) when the LUN does
not exist, or is it just getting that SRB_STATUS_INVALID_LUN error code?
