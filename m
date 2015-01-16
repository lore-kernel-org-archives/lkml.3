Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbbAPGJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:09:24 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:55768 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbbAPGJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:09:21 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.140.40]
In-Reply-To: <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com>
References: <1421269101-51105-1-git-send-email-s-anna@ti.com>
 <1421269101-51105-2-git-send-email-s-anna@ti.com> <20150115135201.GG16217@leverpostej>
 <20150115135556.GH16217@leverpostej> <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 16 Jan 2015 08:09:00 +0200
Message-ID: <CAK=WgbYQ=BbinqJ5fsw2Y+FKdy=nasLsw9mX8pw6S_o3owy9-g@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] Documentation: dt: add common bindings for hwspinlock
To: Rob Herring <robherring2@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Suman Anna <s-anna@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Andersson <bjorn@kryo.se>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 4:42 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Thu, Jan 15, 2015 at 7:55 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> On Thu, Jan 15, 2015 at 01:52:01PM +0000, Mark Rutland wrote:
>>> On Wed, Jan 14, 2015 at 08:58:18PM +0000, Suman Anna wrote:
>>> > +- hwlock-base-id:  An unique base Id for the locks for a particular hwlock
>>> > +                   device. This property is mandatory for all platform
>>> > +                   implementations.
>>>
>>> This property makes no sense. The ID encoded in the hwlock cells is
>>> relative to the instance (identified by phandle), not global. So the DT
>>> has no global ID space.
>>>
>>> Why do you think you need this?
>>
>> Having looked at the way this proeprty is used, NAK.
>>
>> If you need to carve up a Linux-internal ID space, do that dynamically.
>> There is no need for this property.
>
> Better yet, don't create a Linux ID space for this. Everywhere we have
> one, we want to get rid of it.

Rob, Mark,

The hwlock is a basic hardware primitive that allow synchronization
between different processors in the system, which may be running Linux
as well as other operating systems, and may have no other means of
communication.

The hwlock id numbers are predefined, global and static across the
entire system: Linux may boot well after other operating systems are
already running and using these hwlocks to communicate, and therefore,
in order to use these hardware devices, it must not enumerate them
differently than the rest of the system.

Given that these id numbers are global, system-wide, static and
predefined, where Linux may just be one user of them, please
reconsider the approach as implemented by Suman, or suggest an
alternative one you may prefer.

Thanks,
Ohad.
