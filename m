Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbaCQO6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:58:11 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:53673 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbaCQO6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:58:08 -0400
MIME-Version: 1.0
In-Reply-To: <5346848.pBsh8NcQja@wuerfel>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
	<1395057839-23871-3-git-send-email-ks.giri@samsung.com>
	<5346848.pBsh8NcQja@wuerfel>
Date: Mon, 17 Mar 2014 20:28:07 +0530
Message-ID: <CABb+yY0XXMQaEuDV0FeURjOijYEUKyqU9Dr6XTDRcxc1qaBu9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Girish K S <ks.giri@samsung.com>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suman Anna <s-anna@ti.com>, Ilho Lee <ilho215.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 5:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 17 March 2014 17:33:59 Girish K S wrote:
>> +Samsung Mailbox Driver
>> +
>> +Required properties:
>> +- compatible:          Should be one of the following,
>> +                           "samsung,gh7-mailbox" for
>> +                               Samsung GH7 SoC series
>> +                           "samsung,exynos-mailbox" for
>> +                               exynosx SoC series
>> +- reg:                 Contains the mailbox register address range (base address
>> +                       and length)
>> +- interrupts:          Contains the interrupt information for the mailbox
>> +                       device.
>> +- samsung,mbox-names:  Array of the names of the mailboxes
>>
>
> I think we should not allow new mailbox drivers that don't conform to
> the framework that is currently under discussion. In particular, this
> means don't do a "samsung,mbox-names" property. The current consensus
> seems to be to have a #mbox-cells" property that allows to pass extra
> parameters from the client driver, and uses an "mboxes" property
> to reference the mailbox provided.
>
> It would be good if you follow up for the subsystem discussion and
> ensure it gets merged in time, and supports all the use cases you are
> interested in. The interface is not entirely nailed down yet, so
> it's a good time to contribute. However, I can already promise that
> it won't use matching by strings.
>
I was just about to submit next revision of framework that this
Samsung driver conforms to. Now I think I need some expert opinion ...
(sorry if following is repetition)

  As Kumar Gala pointed out in the other thread, the mailbox/ipc chain
is going to be _very_ platform specific so much so that one rethinks
if a common api is even warranted : because the client driver will be
different even if just the remote api(which is going to be
proprietary) changes, keeping everything else same. For example, a
client driver for Highbank is highly unlikely to be reusable on
Exynos, even if both used the same mailbox controller. By my limited
foresight, mailbox assignment via DT doesn't bring us much benefit but
only ritual code.

  Perhaps the mailbox controller driver should name its links as it
wants. By how the remote works with the mailbox links, the client
driver asks for a specific mailbox link (which maybe a hardcoded
string in the driver or be gotten alongside other data via client's
DT) ?

  IOW we can't have a generic API/DT-bindings that could get us
reusable client drivers. But only common framework/code that would
otherwise be duplicated by every platform.

Thanks
Jassi
