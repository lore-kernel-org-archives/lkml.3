Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab3GWRbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:31:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:47953 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3GWRbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:31:52 -0400
Message-ID: <51EEBE05.2040000@linutronix.de>
Date: Tue, 23 Jul 2013 19:31:49 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Bin Liu <binmlist@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after
 removal
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-15-git-send-email-bigeasy@linutronix.de> <CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
In-Reply-To: <CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 07:28 PM, Bin Liu wrote:
> Hi,

Hi,

> 
> On Mon, Jul 22, 2013 at 1:10 PM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de <mailto:bigeasy@linutronix.de>> wrote:
> 
>     This patch adds the MUSB_DEVCTL_SESSION back after it has been removed.
>     If it is missing then the host session is not recognized. This bit is
>     added initially added in musb_start() and removed after the first device
>     disconnect.
> 
> AFAIK, after the device is  disconnected, the OTG state machine will go
> back to B_IDLE/A_IDLE state. SESSION is not needed in this case.


Okay.

> In OTG mode, when no device is plugged, the ID pin is floating, you can
> never hold the host session in this case, even set the SESSION bit. The
> SESSION bit will be cleared by the controller after 100ms.

In my testing the bit remains set. How is the bit supposed to come back
after I connect a host device?

> Regards,
> -Bin.
> 

Sebastian
