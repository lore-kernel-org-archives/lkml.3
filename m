Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3HVKUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 06:20:42 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:56021 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3HVKUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 06:20:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130822100008.2669b0d9@armhf>
References: <20130820120105.55a4c0ce@armhf> <CACxGe6vNKoi47-R3H2sYUhGuX5Lh0nokWaj6Bzw2zv2U0_Wgsg@mail.gmail.com>
 <20130822100008.2669b0d9@armhf>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 22 Aug 2013 11:20:19 +0100
X-Google-Sender-Auth: 3cH-_hwMq4IWv4ngj2YOq2XXn5k
Message-ID: <CACxGe6thGuf2uYD=s0K9=SdoVQmOLYOKVcsXt6wAmxpUjiUFpA@mail.gmail.com>
Subject: Re: [PATCH] of: reduce the number of PROBE_DEFERs
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 9:00 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Tue, 20 Aug 2013 11:13:24 +0100
> Grant Likely <grant.likely@linaro.org> wrote:
>
>> On Tue, Aug 20, 2013 at 11:01 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
>> > This patch populates the platform from the device tree into two steps:
>> > the first step creates the nodes that are referenced by a phandle,
>> > the second step creates the other nodes.
>> >
>> > This permits to reduce the number of PROBE_DEFERs.
>> >
>> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
>> > ---
>> > A better way to reduce probe deferral could be sorting the nodes
>> > according to their phandle level in the DT blob at compilation time ...
>>
>> Have you got measurements or statistics that show this making a
>> difference? I suspect you'll find for boot time it will have little to
>> no affect since the device driver probe order is more closely related
>> to the kernel link order than the order that devices were registered.
>
> With the device tree and most drivers as modules, the kernel link order
> does not matter.
>
> I admit that the gain may be small: I just get none or just one probe
> deferral instead of 3 on my cubox with this patch.

If you've only got 3 probe deferrals, then is this really an issue
worth complicating the code over? I'd like to see a more significant
impact before taking this step.

g.
