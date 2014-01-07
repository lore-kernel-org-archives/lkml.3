Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaAGMPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:15:09 -0500
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:47483 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbaAGMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:15:05 -0500
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 07:15:04 EST
Message-ID: <52CBED8D.2010402@overkiz.com>
Date: Tue, 07 Jan 2014 13:05:33 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-usb@vger.kernel.org
Subject: Re: ohci-at91 mismerge build error
References: <20240208.HaoioSGuhF@wuerfel>
In-Reply-To: <20240208.HaoioSGuhF@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17126907909138708484
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On 07/01/2014 12:54, Arnd Bergmann wrote:
> After commit 99f14bd4d1 "Merge 3.13-rc5 into usb-next" (in linux-next as of
> today), I'm getting this error building any at91 kernel:
>
> drivers/usb/host/ohci-at91.c: In function 'usb_hcd_at91_probe':
> drivers/usb/host/ohci-at91.c:190:4: error: label 'err' used but not defined
>      goto err;
>      ^
> drivers/usb/host/ohci-at91.c: At top level:
> drivers/usb/host/ohci-at91.c:206:2: warning: data definition has no type or storage class [enabled by default]
>    at91_stop_hc(pdev);
>    ^
> ...
>
> The problem is obviously a mismerge between two unrelated changes that
> resulted in missing opening braces.

Thanks for fixing this: I was about to propose the same patch to resolve
the issue introduced by this merge (reported by Olof yesterday).
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
> Please just ignore if this has been reported before
>
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 2d0ee5e..091ae49 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -197,7 +197,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>   	at91_start_hc(pdev);
>   
>   	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
> -	if (retval == 0)
> +	if (retval == 0) {
>   		device_wakeup_enable(hcd->self.controller);
>   		return retval;
>   	}
>

