Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaDIIBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 04:01:43 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37670 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaDIIBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 04:01:41 -0400
Message-ID: <5344FE61.4030306@ti.com>
Date: Wed, 9 Apr 2014 11:01:37 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chao Xu <caesarxuchao@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <stern@rowland.harvard.edu>
Subject: Re: USB: OMAP: questions on patch "Implement runtime idling and remote
 wakeup for OMAP EHCI controller"
References: <CAKZq+reJuhKE6L67RfZL7Zyd6W=cU-ehK3faBKmj3stVg5ukdA@mail.gmail.com>
In-Reply-To: <CAKZq+reJuhKE6L67RfZL7Zyd6W=cU-ehK3faBKmj3stVg5ukdA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/09/2014 07:12 AM, Chao Xu wrote:
> Hi,
> 
> I have two questions about this patch series. Any help is appreciated.
> 1. in the cover letter(https://lkml.org/lkml/2013/7/10/355), it states
> "the series implements suspend/resume for the OMAP EHCI host
> controller during runtime idle". I don't understand when is the EHCI
> host controller "runtime idle"? Does "runtime idle" refers to when all
> attached USB devices are suspended? or does it refer to whenever there
> is no tx/rx ongoing in the EHCI host controller?

It refers to when all USB devices are auto-suspended.

> 
> 2. I think the purpose of the patch is to allow the USB power domain
> (namely, L3INIT power domain) to enter low power state. So assuming

Right.

> the power domain is now in RETENTION state, will the EHCI host be able
> to detect remote wakeup in this case? i.e. will the ULPI DATA0, DATA1
> and DATA3 reflect the Linestate and Interrupt when the L3INIT power
> domain is in RETENTION? Put it in another way, when the power domain
> in is a low power state defined in OMAP spec, is the USB host and PHY
> in  "low power mode" defined in USB spec?

The OMAP EHCI controller is not running and the OMAP USB_HS module is
idle as well and so it can't detect any changes on the ULPI lines.
The PHY is in low power state and should reflect the line status on the DAT0-1
lines.

During the suspended state, we use the IOring mechanism to detect a changed on DAT lines
and wake up the controller/system.

cheers,
-roger

