Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972Ab3CHAEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:04:48 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52885 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3CHAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:04:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130307233116.GF10304@kroah.com>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-31-git-send-email-tj@kernel.org> <20130302181727.GB2051@kroah.com>
 <CAPXgP11Zuz166v_M2EhGDY1U5vKtUwE+fTPAWYEu7UxXsr=g=A@mail.gmail.com>
 <20130305204327.GK12795@htj.dyndns.org> <20130307233116.GF10304@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 8 Mar 2013 01:04:25 +0100
Message-ID: <CAPXgP10CEMgdOW23txWwwh0xSVd97fKH31xdKjE8Wy51kO6XdQ@mail.gmail.com>
Subject: Re: [PATCH 30/31] driver/base: implement subsys_virtual_register()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 12:31 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 05, 2013 at 12:43:27PM -0800, Tejun Heo wrote:
>> On Sun, Mar 03, 2013 at 07:42:31AM +0100, Kay Sievers wrote:
>> > On Sat, Mar 2, 2013 at 7:17 PM, Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> > > On Fri, Mar 01, 2013 at 07:24:21PM -0800, Tejun Heo wrote:
>> > >> Kay tells me the most appropriate place to expose workqueues to
>> > >> userland would be /sys/devices/virtual/workqueues/WQ_NAME which is
>> > >> symlinked to /sys/bus/workqueue/devices/WQ_NAME and that we're lacking
>> > >> a way to do that outside of driver core as virtual_device_parent()
>> > >> isn't exported and there's no inteface to conveniently create a
>> > >> virtual subsystem.
>> > >
>> > > I'm almost afraid to ask what you want to export to userspace for a
>> > > workqueue that userspace would care about...
>> > >
>> > > If you create a subsystem, the devices will show up under the virtual
>> > > "bus" if you don't give them a parent, so this patch shouldn't be
>> > > needed, unless you are abusing the driver model.  What am I missing
>> > > here?
>> >
>> > Unfortunately, the parent == NULL --> /sys/devices/virtual/<subsys>/
>> > we have only implemented for classes, and not for buses. We should fix
>> > that.
>>
>> Greg, how should I proceed on this?  As I wrote before, I don't really
>> care about where or how.  As long as I can make workqueues visible to
>> userland, I'm happy.
>
> Sorry for the delay, I'm at a conference all this week, and haven't had
> much time to think about this.
>
> If Kay says this is ok for now, that's good enough for me.

Yes, it looks fine to me. If we provide the unified handling of
classes and buses some day, this can probably go away, but until that
it looks fine and is straight forward to do it that way,

Thanks,
Kay
