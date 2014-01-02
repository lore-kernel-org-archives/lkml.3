Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaABVBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:01:39 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:64307 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:01:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=SI6Xm9
	KTkku1I1CSsk7kbgY59NsD8n8BpYM3QORQmCpSkkFQF+uYZk4r6G9BZQy9isyrGJ
	xMARdW6P5AjVaJqeDjE0XdWnWtvKapvOabyScjYiho/jk7Js19DI2ug/8ZjCSYef
	RKbnNq3Uf8b274qusFYBnxhFj0a+TvIBXZ5Dc=
Message-ID: <52C5D3A9.60708@pobox.com>
Date: Thu, 02 Jan 2014 16:01:29 -0500
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>, walt <w41ter@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos>
In-Reply-To: <20140102191510.GA9621@xanatos>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 0DCB443E-73F1-11E3-A8A9-873F0E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-02 02:15 PM, Sarah Sharp wrote:
> On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
..
>> Unfortunately this patch causes a regression when copying large files to my
>> outboard USB3 drive. (Nothing at all to do with networking.)
>>
>> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
>> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
>>
>> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
>> patch completely fixes the problem.
> 
> Ok, I had feared that would be a consequence of this patch.  I think the
> problem is that the usb-storage driver submitted an URB with more
> scatter-gather entries than would fit on the ring segment, the xHCI
> driver rejected the URB with -ENOMEM, and the SCSI core eventually gave
> up on the SCSI command.


Is there not a block layer / scheduler tunable for max sg entries or something?
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
