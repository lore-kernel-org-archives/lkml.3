Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaILQpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:45:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20345 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaILQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:45:04 -0400
X-AuditID: cbfee61a-f79e46d00000134f-9c-5413230d1fba
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 00/12] usb: dwc2: Add support for dual role
Date: Fri, 12 Sep 2014 18:44:59 +0200
Message-id: <61330867.p68uWknPkl@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jQV1eZeEQg1U7LC0O3q+3mLTuAJPF
	2WUH2SxWfVrDbLHypLZF8+L1bBaXF15itdg2/SeQtWsOm8WiZa3MFgtfX2Ox2D5lOpPFg8M7
	2S1O/ulltHh1sI3Fgd9jdsNFFo+/q14we+ycdZfd4861PWwe++euYffovzaJ3ePvrP0sHn1b
	VjF6fPnxj8Vjy/7PjB7Hb2xn8vi8Sc5j49zQAN4oLpuU1JzMstQifbsErowTi8+wFvTwVrzd
	dpa1gXEtVxcjJ4eEgInEklf/mCBsMYkL99azdTFycQgJTGeU2HNxEyuE08IkcW7DREaQKjYB
	K4mJ7avAbBEBJYneVS9ZQIqYBc4ySazYtZYZJCEs4CjxZO8RsLEsAqoS+zbuZAGxeQW0JJZs
	vQ3WLCrgKbFj+0qgdRwcnAL+Eu0fDEHCQgJ+Eq13D7BClAtK/Jh8D6yVWUBeYt/+qawQto7E
	/tZpbBMYBWYhKZuFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj8JnUDsaV
	DRaHGAU4GJV4eCtYBEOEWBPLiitzDzFKcDArifAqigqHCPGmJFZWpRblxxeV5qQWH2KU5mBR
	Euc90GodKCSQnliSmp2aWpBaBJNl4uCUamDc7384OXSrzKM7FguO8UZ9zhFzSux40j61zOpQ
	76Tfrdy3tv1reyn1pGLC+bgJL2+vl/COOXu6Xcb9jZKjwewG5vLvIacZ9X6aeNR+TeFflHi9
	Z6tRUnb73gYHDg3FbQ7VkpwPztlunRX1bObD0F3aoqw3mjjam/1t2RX8W34t9lzhPqns63El
	luKMREMt5qLiRAA1wlfzvAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:19:51 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Hello,
> 
> This is version 4 of the patch series that combines the dwc2 gadget and host
> driver into a single dual role driver. Here are the main differences from V2:
> 
> - Patch 9/12 : Move spin_lock_init() earlier up in the function to guarantee
>   no locks can be taken before the initializing the spin_lock.
> 
> - Patch 12/12 : Same as patch 9/12.
> 
> - Added Acked-by: paulz for all patches except patch 9/12 and 12/12.
> 
> For v4, I have rebased the series on top of Greg KH's USB usb-linus tree
> [9b2667f usb: dwc2: gadget: Set the default EP max packet value as 8 bytes]
> and on top of the following patches that have not yet been applied:
> 
> Doug Anderson: usb: dwc2: Read GNPTXFSIZ when in forced HOST mode
> Kever Yang : usb: dwc2: add 'mode' which based on Kconfig select or dts setting
> Robert Baldyga : usb: dwc2/gadget: fix series <- 12 patches
> 
> As usual, tested on SOCFPGA(host, gadget, and dual-role) and on Rpi-B
> (host mode only).
> 
> I have pushed this series to a git repo to make it more convenient for people
> to test/review.
> 
> git://git.rocketboards.org/linux-socfpga-next.git dwc2_dual_role_v4

Please also add linux-kernel ML to next revision of the patchset
(helps to get reviewers).

Also sorry for the late review but people are not yet used to
the fact that dwc2 now also means "our" good old s3c-hsotg. ;-)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

