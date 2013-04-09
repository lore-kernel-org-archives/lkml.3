Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935759Ab3DITVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 15:21:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41017 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759304Ab3DITVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 15:21:31 -0400
Message-ID: <51646A15.8060004@oracle.com>
Date: Tue, 09 Apr 2013 13:20:53 -0600
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: "bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mce: Print warning if MCE handler fails to register
 /dev/mcelog
References: <1365531571.8447.4.camel@concerto> <3908561D78D1C84285E8C5FCA982C28F1EA41C2B@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1EA41C2B@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 12:30 PM, Luck, Tony wrote:
> -	misc_register(&mce_chrdev_device);
> +	if (misc_register(&mce_chrdev_device) != 0)
> +		pr_warn("Failed to register mcelog device\n");
>
> Did this actually happen to you?  Or is this just "good practice" to check the
> return value from misc_register?
>

No, I did not see this happen. It is just "good practice". If it were to 
happen, mcelog daemon would fail to get any mce records and it will not 
be easy to figure out what happened. Most other places in kernel where 
misc_register() is called, do check for return code and take action if 
it fails.

--
Khalid

