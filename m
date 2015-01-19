Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbbASHkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:40:52 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52561 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbASHkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:40:51 -0500
Date: Mon, 19 Jan 2015 07:40:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: =?utf-8?B?5pWs6ZSQ?= <micky_ching@realsil.com.cn>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rogerable@realtek.com" <rogerable@realtek.com>,
        =?utf-8?B?546L54Kc?= <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 08/10] mfd: rtsx: add support for rts524A
Message-ID: <20150119074046.GM3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <007fcaa1986088c968cd4d1627c294a55df73e9f.1421320541.git.micky_ching@realsil.com.cn>
 <20150118122055.GK3574@x1>
 <54BC6DA1.80205@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BC6DA1.80205@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, 敬锐 wrote:

> 
> On 01/18/2015 08:20 PM, Lee Jones wrote:
> >> +static int rts524a_optimize_phy(struct rtsx_pcr *pcr)
> >> >+{
> >> >+	int err;
> >> >+
> >> >+	err = rtsx_pci_write_register(pcr, RTS524A_PM_CTRL3,
> >> >+		D3_DELINK_MODE_EN, 0x00);
> >> >+	if (err < 0)
> >> >+		return err;
> > if (err)
> >
> err value will never be positive, but I have to make it consistence
> with driver in other place, because all the check using if (err < 0) form.

Then all of them should be changed.

> And maybe, it make reserved for future the function may return positive
> value.

I'd prefer not to live in the world of 'what if'.  I think only
checking for a less than zero error value insinuates that a greater
than zero return is acceptable, but in this case is it not.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
