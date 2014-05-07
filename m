Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbaEGQIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:08:15 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58806 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaEGQIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAJAp7OiyjefyPMu2p8jTkbfQWYUKeYV62pVTtJ2JOP-6YOOGKA@mail.gmail.com>
References: <536982E3.10303@gmail.com>
	<CAL_JsqL6+i_ED+s6kODsadszefaZUcA7VHCfZ4k4yj62iXsarQ@mail.gmail.com>
	<CAJAp7OiyjefyPMu2p8jTkbfQWYUKeYV62pVTtJ2JOP-6YOOGKA@mail.gmail.com>
Date: Wed, 7 May 2014 11:08:12 -0500
Message-ID: <CAL_JsqK5-kAHTgk=nbHToU9sU5fVW+mGXX9rBaYqw57x0Vkqdw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] devicetree, qcomm PMIC: fix node name conflict
From: Rob Herring <robherring2@gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Frank Rowand <frowand.list@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 10:12 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Tue, May 6, 2014 at 6:32 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On Tue, May 6, 2014 at 7:48 PM, Frank Rowand <frowand.list@gmail.com> wrote:
>>> An issue with the path of SPMI nodes under /sys/bus/... was reported in
>>> https://lkml.org/lkml/2014/4/23/312.  The symptom is that two different
>>> grandchild nodes of the spmi with the same node-name@unit-address will
>>> result in attempting to create duplicate links at
>>> /sys/bus/platform/devices/unit-address.node-name.  It turns out that the
>>> specific example provided might not be an expected configuration for
>>> current hardware, but the reported trap remains an issue.

[...]

>> This can be solved in a much less invasive way just in the DT naming
>> algorithm. This is slightly different from what I had suggested of
>> just dropping the unit address. It keeps the unit address, but adds
>> the unique index on untranslate-able addresses. The diff is bigger due
>> to refactoring to reduce the indentation levels. It is untested and
>> whitespace corrupted:
>
> The unique index leads to an interesting dependency between the order
> of nodes in the DTB and userspace; paths to e.g. our the path to our
> block devices contains soc.X where X changes now and then. Fortunately
> soc.X won't change that often, but forcing more peripheral nodes to use
> the same schema would show the problem quite often.

Userspace depending on the device names is broken and device names are
not considered part of the sysfs ABI. So devices having randomish
names is a feature. The names and location change when platforms
convert to DT. The location changes when someone decides to add an soc
device to a platform as well.

> Does translatable/untranslatable refer to if this is an address translatable
> my the cpu or that it's just a translatable address on this specific bus?
> As far as I can see it's the latter and in our case (revid { reg =
> <0x100, 0x100>; })
> seem to be translatable with the current implementation.

It should be the former. If the current behavior is the latter, then
the problem is in a different spot.

Rob
