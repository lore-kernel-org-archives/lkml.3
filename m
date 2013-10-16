Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab3JPSRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:17:37 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35586 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214Ab3JPSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:17:34 -0400
MIME-Version: 1.0
In-Reply-To: <20131016150732.GY2954@intel.com>
References: <1381527738-9339-2-git-send-email-youquan.song@intel.com>
	<20131011133343.GB32689@kroah.com>
	<20131013152633.GM2954@intel.com>
	<20131015183142.GA12494@linux-youquan.bj.intel.com>
	<CAPcyv4jJSgM7EmDMW-rcjVCnC6-95+qeU9yf+yxD-wMCcQ8amg@mail.gmail.com>
	<20131016053857.GV2954@intel.com>
	<1381912571.29062.135.camel@smile>
	<20131016075702.GW2954@intel.com>
	<1381914782.29062.137.camel@smile>
	<20131016141247.GB17567@kroah.com>
	<20131016150732.GY2954@intel.com>
Date: Wed, 16 Oct 2013 11:17:33 -0700
Message-ID: <CAPcyv4g31hkFwA5E2bxWt2dPRbvzxmiFj-+35AooiTPp8JdK0Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] dma: Add interface to calculate data transferred
From: Dan Williams <dan.j.williams@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Youquan Song <youquan.song@linux.jf.intel.com>,
        "Song, Youquan" <youquan.song@intel.com>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 8:07 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, Oct 16, 2013 at 07:12:47AM -0700, Greg KH wrote:
>> On Wed, Oct 16, 2013 at 09:13:20AM +0000, Shevchenko, Andriy wrote:
>> > On Wed, 2013-10-16 at 13:27 +0530, Vinod Koul wrote:
>> > > On Wed, Oct 16, 2013 at 02:06:30PM +0530, Shevchenko, Andriy wrote:
>> > > > On Wed, 2013-10-16 at 11:08 +0530, Vinod Koul wrote:
>> >
>> > []
>> >
>> > > > > Well am going to take it a bit further and ask you why do we need the
>> > > > > /sys/class/dma? I have never used it for slave work.
>> > > >
>> > > > How user (who, f.e., would like to run dmatest) will know names of the
>> > > > channels provided?
>> > > Ok dmatest requires this, I overlooked that part
>> > >
>> > > > How could we see what channels of certain dma controller are requested /
>> > > > busy from userspace?
>> > > But do end user care or need to know about this?
>> >
>> > The idea is to have some test cases. So, end user probably doesn't
>> > really need this.
>>
>> So could this just be debugfs files instead?
> Yes I was thinking on same lines and would agree with you on that. This _really_
> doesn't need sysfs unless Dan some async usage dependent on it. While at it we
> can review the fields and remove the ones which are not required...
>
> Dan, let me know if you are okay with it, I will try to get that done over the
> weekend...
>

Channel naming is the primary use case and several drivers rely on the
channel name in their print messages, some for naming resources, and
of course dmatest for identifying channels.  ioatdma uses it as a
parent device for allocating its per-channel 'quickdata' attributes to
advertise the capabilities and the ring_size which is useful for
determining channel loading and verifying the BIOS configuration.

An argument could be made to move the ioatdma attributes to debugfs,
but I don't see a clean/worthwhile way of ripping and replacing the
channel naming scheme for drivers.

--
Dan
