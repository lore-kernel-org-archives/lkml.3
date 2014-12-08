Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaLHGOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:14:10 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:64255 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaLHGOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:14:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141207114829.GX3411@intel.com>
References: <1416002384-3525-1-git-send-email-abrestic@chromium.org>
	<1416002384-3525-3-git-send-email-abrestic@chromium.org>
	<20141205173553.GS3411@intel.com>
	<CAL1qeaE+7L2p=HxPBasQYLVPD0H2qBAd439Fn_z3Fza9Y3+0eA@mail.gmail.com>
	<20141207114829.GX3411@intel.com>
Date: Sun, 7 Dec 2014 22:14:05 -0800
X-Google-Sender-Auth: sa5E8bHdaZlzRjEJEUAaVuaGokw
Message-ID: <CAL1qeaFDZV2FiuHqRAzsaYUmoV72Kaq8o0di7CueUrN6qzrT+w@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] dmaengine: Add driver for IMG MDC
From: Andrew Bresticker <abrestic@chromium.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>,
        Arnd Bergmann <arnd@arndb.de>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 7, 2014 at 3:48 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Fri, Dec 05, 2014 at 10:30:53AM -0800, Andrew Bresticker wrote:
>> After adding a macro for setting the WIDTH_{R,W} fields it seems fine
>> to me.  Is there something else you had in mind?
> I think whole of this might be a macro :)
>
>
>> > and this depends on dma_slave_config being set, which shouldn't be the case
>> > for memcpy

> okay looking back yes it depends on bus_width. But how is bus_width set, i
> thought the dma_slave_config will set that?

The MDC's memory bus width is read from a HW register and set in probe().
