Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaHKL4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:56:23 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48770 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaHKL4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:56:21 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Thread-Topic: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Thread-Index: AQHPtThds7tfTj7cqkq3IdcFv++16pvLASuAgABJAYA=
Date: Mon, 11 Aug 2014 11:56:17 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2B2AE@EU-MBX-02.mgc.mentorg.com>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140811082811.GC1422@kroah.com>
In-Reply-To: <20140811082811.GC1422@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 11 Aug 2014 11:56:19.0222 (UTC) FILETIME=[43441360:01CFB55B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please find my comment in line.

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Monday, August 11, 2014 1:58 PM
To: Sharma, Sanjeev
Cc: hdegoede@redhat.com; kraxel@redhat.com; mdharm-usb@one-eyed-alien.net; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().

On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> spin_is_locked() always return false in uniprocessor configuration

Really?  On what processor type?  I don't see that being the case on a few processors, but I didn't check them all, or I might be totally confused with all of the arch_spin_is_locked() definitions in the tree.

specially in case of mips and powerpc but we can configure our kernel to uniprocessor configuration for specific processor and in that case we should be extra cautious. Please check spinlock_up.h

> and therefore it
> would be advise to repalce with assert_spin_locked().

This implies that all uses of this function is wrong and should be replaced and removed, right?

Yes and there are only few places in driver for which I am submitting patches which need to be change and at other places it has been already taken care. Please have an look into the
Old discussion for more details.

http://linux-kernel.2935.n7.nabble.com/Is-spin-is-locked-safe-to-use-with-BUG-ON-WARN-ON-td654800.html#a921802

thanks,

greg k-h
