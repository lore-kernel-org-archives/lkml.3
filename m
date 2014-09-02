Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaIBRzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:55:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaIBRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:55:08 -0400
Date: Tue, 2 Sep 2014 10:55:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] drivers: base: add cpu_device_create to support per-cpu
 devices
Message-ID: <20140902175507.GA14564@kroah.com>
References: <CAPXgP130hg8uwdmSKAAAKZzxncT-VXYYXvmN-ta7wcXQXgXEmw@mail.gmail.com>
 <1408706963-23195-1-git-send-email-sudeep.holla@arm.com>
 <5405FCBF.2050100@arm.com>
 <20140902172632.GA8238@kroah.com>
 <54060105.5070707@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54060105.5070707@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:40:21PM +0100, Sudeep Holla wrote:
> Hi Greg,
> 
> On 02/09/14 18:26, Greg Kroah-Hartman wrote:
> >On Tue, Sep 02, 2014 at 06:22:07PM +0100, Sudeep Holla wrote:
> >>Hi Greg,
> >>
> >>On 22/08/14 12:29, Sudeep Holla wrote:
> >>>From: Sudeep Holla <sudeep.holla@arm.com>
> >>>
> >>>This patch adds a new function to create per-cpu devices.
> >>>This helps in:
> >>>1. reusing the device infrastructure to create any cpu related
> >>>    attributes and corresponding sysfs instead of creating and
> >>>    dealing with raw kobjects directly
> >>>2. retaining the legacy path(/sys/devices/system/cpu/..) to support
> >>>    existing sysfs ABI
> >>>3. avoiding to create links in the bus directory pointing to the
> >>>    device as there would be per-cpu instance of these devices with
> >>>    the same name since dev->bus is not populated to cpu_sysbus on
> >>>    purpose
> >>>
> >>>Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> >>>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>---
> >>>  drivers/base/cpu.c  | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>>  include/linux/cpu.h |  4 ++++
> >>>  2 files changed, 58 insertions(+)
> >>>
> >>>Hi Greg,
> >>>
> >>>Here is the alternate solution I could come up with instead of
> >>>creating cpu class. cpu_device_create is very similar to
> >>>device_create_groups_vargs w/o class support, but I could not
> >>>reuse anything else to avoid creating similar function.
> >>>
> >>>Let me know your thoughts/suggestions on this.
> >>>
> >>
> >>Any feedback on this ? If ok, I will respin cacheinfo series removing
> >>cpu class creation with this patch.
> >
> >Please address the issues others have already raised.
> >
> 
> If you meant issues raised on cacheinfo series, I have addressed them
> already in v3(raised by you, Stephen Boyd, Mark and Russell). I have
> retained hotplug notifiers which Stephen wanted to remove as I don't
> know if that's acceptable on all the architectures.
> 
> I posted this single patch as a replacement to the patch creating cpu
> class as Kay and David suggested that we can't have class and bus with
> same name.

Then I have no idea what is going on, sorry, please respin as you see
fit and resend...

thanks,

greg k-h
