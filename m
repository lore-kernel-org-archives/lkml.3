Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159AbaFXBtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:49:15 -0400
Received: from smtpbg347.qq.com ([58.250.132.66]:56242 "EHLO smtpbg347.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaFXBtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:49:14 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 21:49:13 EDT
X-QQ-mid: esmtp32t1403573977t095t21062
X-QQ-SSF: 0100000000000000021202000000003
X-QQ-FEAT: MHYjH6aD5Oiy2BJPEUy0AqcBbhCNnRx+sjrWpnZ6P+3TZNr1QUtXN3bU23bzN
	DzJGv53x+0Pe8azoiTQhKA7YptCfwocttl7jTnhi39BKzghJth8AnkxlghD7zwse1NfwrZy
	3RZQyw451iQ01sXTcA==
X-QQ-GoodBg: 0
Message-ID: <53A8D6C1.20709@foxmail.com>
Date: Tue, 24 Jun 2014 09:39:13 +0800
From: Roy <yunzhi.li@foxmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: r.baldyga@samsung.com, balbi@ti.com, dinguyen@altera.com,
        andrzej.p@samsung.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, paulz@synopsys.com
Subject: Re: [PATCH 00/11] usb: dwc2/gadget: fix series
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

When I trace the s3c-gadget driver, I found that the driver did not use
DMA mode because of the 32bit align problem. Have you solved this
problem ? I think just do one more time copy when meet the unalign
buffer address can make the DMA mode work correctly. Does any body have
more suggestions on this issue?

on 2014/6/23 15:51, Robert Baldyga wrote:
> Hello,
>
> This patchset contains fixes for dwc2 gadget driver. It touches PHY,
> FIFO configuration, initialization sequence and adds many other small fixes.
>
> Best regards
> Robert Baldyga
> Samsung R&D Institute Poland
>
> Andrzej Pietrasiewicz (1):
>   usb: dwc2/gadget: Fix comment text
>
> Kamil Debski (3):
>   usb: dwc2/gadget: fix phy disable sequence
>   usb: dwc2/gadget: fix phy initialization sequence
>   usb: dwc2/gadget: move phy bus legth initialization
>
> Marek Szyprowski (5):
>   usb: dwc2/gadget: hide some not really needed debug messages
>   usb: dwc2/gadget: ensure that all fifos have correct memory buffers
>   usb: dwc2/gadget: break infinite loop in endpoint disable code
>   usb: dwc2/gadget: do not call disconnect method in pullup
>   usb: dwc2/gadget: delay enabling irq once hardware is configured
>     properly
>
> Robert Baldyga (2):
>   usb: dwc2/gadget: assign TX FIFO dynamically
>   usb: dwc2/gadget: disable clock when it's not needed
>
>  drivers/usb/dwc2/core.h   |   2 +
>  drivers/usb/dwc2/gadget.c | 150 ++++++++++++++++++++++++++++------------------
>  2 files changed, 93 insertions(+), 59 deletions(-)
>

-- 
--------
Roy Li @ Rockchip

