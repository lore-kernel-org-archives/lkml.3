Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbaAGAEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:04:05 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:57317 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbaAGAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
References: <52B0AEAD.6050604@gmail.com> <20131218010207.GC15119@google.com> <CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 6 Jan 2014 17:03:39 -0700
Message-ID: <CAErSpo6A0=0Ph22vMZ1_eC1L7ndoi5S6162zRDYkMoPf53Fhcg@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
To: Rajat Jain <rajatxjain@gmail.com>
Cc: Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, Guenter Roeck <groeck@juniper.net>,
        Rajat Jain <rajatjain@juniper.net>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 10:53 AM, Rajat Jain <rajatxjain@gmail.com> wrote:
> Hello Bjorn,
>
> Just checking on the fate of this patch set...
>
> On Tue, Dec 17, 2013 at 5:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
>>
>> On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
>>> We need future link up events for hot-add, thus don't disable
>>> the link permanently during device removal. Also, remove the static
>>> functions that are now left unused.
>>
>> The changelog should mention that this reverts part of 2debd9289997 ("PCI:
>> pciehp: Disable/enable link during slot power off/on").
>
> Sure. Do you want me to submit another patch set (bumping up the
> version) with this change log, or you'd want to add this change log
> while merging?
>
>>
>> Yinghai, can you tell us whether this is an issue on your systems?
>
> As Yinghai confirms further down this thread, his issue was confirmed
> by Intel to be a bug in the repeater chip.
> ----------------------------------
> Yinghai writes:
>> According to HW guys and Intel, that should be bug of repeater.
>>
> ---------------------------------
>  I don't know about the details of his scenario, except that when the
> adapter was disabled the repeater kept on flapping the link up & down
> (and hence disabling the link solved the problem then). Yinghai
> couldn't test, but I believe with this patch even if we disable
> presence detect interrupt, the "adapter present / no present" messages
> would (rightly) convert to "Link Up / Link Down" messages (since the
> repeater keeps on flapping the link).
>
> Since it is a platform specific bug, I'm not sure what can be done to
> remove those messages except may be reduce the verbosity? If you'd
> like I could change all the INFO messages to DBG messages.

Even if it's a defect in a particular piece of hardware, I don't want
to regress on that hardware, even if the regression is just extra
messages that we didn't see before.

I think ideally we would add some sort of quirk for that hardware so
it works just as well as it does today.  I think extra messages will
lead to a bug reports from users.

Bjorn
