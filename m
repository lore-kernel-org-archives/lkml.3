Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaH2Hjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:39:39 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:48636 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaH2Hjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:39:37 -0400
Message-ID: <54002E2E.7030301@acm.org>
Date: Fri, 29 Aug 2014 09:39:26 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Christoph Hellwig <hch@infradead.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>
CC: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
References: <1408244954-27417-1-git-send-email-kys@microsoft.com> <1408244988-27456-1-git-send-email-kys@microsoft.com> <1408244988-27456-2-git-send-email-kys@microsoft.com> <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de> <53FFE87B.9040802@cs.wisc.edu> <54001B5F.9040506@suse.de>
In-Reply-To: <54001B5F.9040506@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/14 08:19, Hannes Reinecke wrote:
> On 08/29/2014 04:42 AM, Mike Christie wrote:
>> How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
>> gets passed to userspace? Is everyone kicking off a new full (add and
>> delete) scan to handle this or logging it? Is the driver returning this
>> when the LUNs change?
>>
> Currently it's logged to userspace and ignored.
> Doing an automated rescan has proven to be dangerous, as it
> might disconnect any LUNs which are still in use by applications.
> Especially HA or database setups tends to become very annoyed
> when you do an automated rescan.

Has it already been considered to add newly discovered LUNs
automatically and to leave it to the user to remove stale LUNs manually
? That would be similar to what the rescan-scsi-bus.sh script does
without option -r/--remove.

Bart.

