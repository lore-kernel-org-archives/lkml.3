Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3LRWDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:03:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51481 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3LRWDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 17:03:06 -0500
Message-ID: <52B21B7E.1020307@zytor.com>
Date: Wed, 18 Dec 2013 14:02:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, arnd@arndb.de,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] misc: Reserve minor for VFIO
References: <20131218204024.30540.55302.stgit@bling.home> <20131218210141.GA11267@kroah.com>
In-Reply-To: <20131218210141.GA11267@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 01:01 PM, Greg KH wrote:
> On Wed, Dec 18, 2013 at 01:56:32PM -0700, Alex Williamson wrote:
>> VFIO currently allocates it's own dynamic chardev range, reserving the
>> first minor for the control part of the interface (/dev/vfio/vfio) and
>> the remainder for VFIO groups (/dev/vfio/$GROUP).  This works, but it
>> doesn't support auto loading.  For instance when libvirt checks for
>> VFIO support it looks for /dev/vfio/vfio, which currently doesn't
>> exist unless the vfio module is loaded.  By converting the control
>> device to a misc driver and reserving a static minor, we can enable
>> auto loading.
>>
>> Reserving the minor is a prerequist to that conversion.  Minor 196
>> is unused by anything currently in the kernel.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>> ---
>>
>> v2: Plea for ack edition
>>
>> As Alan suspected, there's been no response from device@lanana.org,
>> so there's probably nobody monitoring it anymore.  I've done due
>> diligence looking at all the callers of misc_register() in linux-next
>> and cannot find any conflicts with minor 196.  If anyone wants to toss
>> me an ack or sign-off I'll be happy to bring this in through my vfio
>> tree, otherwise I'd appreciate if someone wants to take it directly.
>> Thanks!
>>
>>  Documentation/devices.txt  |    1 +
>>  include/linux/miscdevice.h |    1 +
>>  2 files changed, 2 insertions(+)
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

I think Alan Cox was the last person to man <device@lanana.org>... Alan,
are you still doing that?  (Otherwise patching the file in the Linux
kernel tree seems eminently sensible... there really isn't any need to
reserve numbers for out-of-tree drivers anymore.  Just another perk of
being in-tree.)

	-hpa


