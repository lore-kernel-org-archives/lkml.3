Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab3DBOxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:53:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:61528 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab3DBOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:53:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,394,1363132800"; 
   d="scan'208";a="16127942"
Message-ID: <515AF0D9.80805@citrix.com>
Date: Tue, 2 Apr 2013 15:53:13 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        Keir Fraser <keir.fraser@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen/evtchn: Handle VIRQ_TIMER before any
 other hardirq in event loop.
References: <1364825261-25324-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1364825261-25324-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/13 15:07, Konrad Rzeszutek Wilk wrote:
> From: Keir Fraser <keir.fraser@citrix.com>
> 
> This avoids any other hardirq handler seeing a very stale jiffies
> value immediately after wakeup from a long idle period. The one
> observable symptom of this was a USB keyboard, with software keyboard
> repeat, which would always repeat a key immediately that it was
> pressed. This is due to the key press waking the guest, the key
> handler immediately runs, sees an old jiffies value, and then that
> jiffies value significantly updated, before the key is unpressed.

It's a bit of hack but what else can you do when there is no generic
mechanism to have different event priorities.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

The subject should be prefixed with: "xen/events" as this isn't a patch
to the evtchn driver.

David
