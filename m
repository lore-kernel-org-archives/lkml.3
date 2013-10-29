Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab3J2O0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:26:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:8918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339Ab3J2O0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="426493249"
Message-ID: <526FC51A.2080008@linux.intel.com>
Date: Tue, 29 Oct 2013 07:24:26 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/2] usb: ffs/dwc3: pad epout buffer size when not
 aligned to maxpacketsize
References: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com> <1383009180-23236-3-git-send-email-david.a.cohen@linux.intel.com> <20131029133724.GH2776@gimli>
In-Reply-To: <20131029133724.GH2776@gimli>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +		/*
>> +		 * DWC3 requires buffer size to be aligned to maxpacketsize
>> +		 * of an out endpoint.
>> +		 * FIXME: a more generic solution might be necessary.
>> +		 */
> 
> see, gadget drivers shouldn't have to know about DWC3 at all. They need
> to know that current UDC has a quirk where EP OUT transactions need to
> be aligned to wMaxPacketSize, so what I was expecting to see here was:
> 
> 		if (test_bit(USB_GADGET_QUIRK_EP_OUT_ALIGNED_SIZE, &gadget->qirks) &&
> 			!IS_ALIGNED(len, ep->ep->desc->wMaxPacketSize))
> 			len = align_length(orig_len, wMaxPacketSize);

That makes sense. I'll send a new version.

Thanks,

David Cohen

