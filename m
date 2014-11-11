Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKKI7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:59:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42690 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaKKI7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:59:46 -0500
Message-ID: <5461CFFA.6030102@ti.com>
Date: Tue, 11 Nov 2014 14:29:38 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>, Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv70=?= =?UTF-8?B?Zw==?= 
	<arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
References: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org> <20141110152645.GF20766@saruman>
In-Reply-To: <20141110152645.GF20766@saruman>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Monday 10 November 2014 08:56 PM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Nov 04, 2014 at 03:30:54PM +0530, Kiran Kumar Raparthy wrote:
>> @@ -1469,6 +1484,7 @@ static int ab8500_usb_probe(struct platform_device *pdev)
>>  
>>  	abx500_usb_link_status_update(ab);
>>  
>> +	usb_phy_wsource_init(&ab->phy);
> 
> instead of adding this to all drivers, you can just it to
> usb_add_phy_dev() and conversely, to usb_remove_phy().

'usb_phy_wsource_init' seems specific to usb and when these drivers are adapted
to the generic PHY framework we can't add it to phy_create.

Should it be added in extcon instead?

Thanks
Kishon
