Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3K0REk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:04:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:12050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3K0REh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:04:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="443147053"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "Chandramouli\, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        "Dutt\, Sudeep" <sudeep.dutt@intel.com>,
        "Rao\, Nikhil" <nikhil.rao@intel.com>,
        "Yerramreddy\, Siva Krishna Kumar Reddy" 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        "Yokoyama\, Caz" <caz.yokoyama@intel.com>,
        "Wu\, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [PATCH char-misc-linus 4/5] misc: mic: Fix sparse warnings and other endianness issues.
References: <cover.1385487752.git.ashutosh.dixit@intel.com>
	<e5bcd02bd49b111e2d4f885655461e889b8049a3.1385487752.git.ashutosh.dixit@intel.com>
	<20131126191525.GA29279@kroah.com>
Date: Wed, 27 Nov 2013 09:12:01 -0800
In-Reply-To: <20131126191525.GA29279@kroah.com> (Greg Kroah-Hartman's message
	of "Tue, 26 Nov 2013 12:15:25 -0700")
Message-ID: <m3zjopwyzi.fsf@adixit-yct.ra.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26 2013 at 11:15:25 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 26, 2013 at 10:14:21AM -0800, Ashutosh Dixit wrote:
>> Endianness issues are now consistent as per the documentation in
>> host/mic_virtio.h. Note that the host can be both BE or LE whereas the
>> card is always LE.
>>
>> Memory space sparse warnings are fixed for now by using __force. This is
>> sufficient for now since the driver depends on x86 but will need to be
>> revisited if we support other architectures which treat I/O memory
>> differently from system memory.
>
> Can you split the endian fixes up from the user pointer fixes to make it
> easier to review/apply?

We've just submitted v3 where we now have separate patches (5 and 6) for
endianness and sparse memory access fixes.

> There's no need for this for 3.13-final, right?  No bug fixes are here
> that I can tell.

That's correct.  I've reordered the patches so that v3 patches 1-4
contain the real bug fixes. We'd like to apply patches 5 and 6 for
3.13-final too but if it is not possible we can drop one or both of them
for now for further review.

> And don't use __force, really, can't you fix this some other way?

As stated in the description for patch 6, because of the dependence of
the MIC drivers on the virtio infrastructure there is no simple way to
fix these memory space issues at present. Since the sparse warnings do
not represent real issues the warnings are being suppressed using
__force.

>> +	vq = vring_new_virtqueue(index, le16_to_cpu(config.num),
>> +				 MIC_VIRTIO_RING_ALIGN, vdev, false,
>> +				 (void __force *)va, mic_notify, callback,
>> +				 name);
>
> Why __force a void * here?  That feels wrong.

In all instances in patch 6 __force is used to strip the __iomem
attribute (e.g. va is declared as 'void __iomem *va;').

thanks,

ashutosh
