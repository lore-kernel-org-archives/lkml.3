Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaKLFWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 00:22:04 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:36255 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaKLFWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 00:22:01 -0500
Message-ID: <5462EE6C.3070202@roeck-us.net>
Date: Tue, 11 Nov 2014 21:21:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/123] 3.10.60-stable review
References: <20141112011718.985171261@linuxfoundation.org>
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.5462EE78.0153,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 05:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.60 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 14 01:17:00 UTC 2014.
> Anything received after that time might be too late.
>

As an early heads up, I see some builds failing in 3.10 and 3.14 with

drivers/of/selftest.c: In function 'of_selftest':
drivers/of/selftest.c:224:2: error: implicit declaration of function 'of_selftest_property_match_string' [-Werror=implicit-function-declaration]
   of_selftest_property_match_string();
   ^
drivers/of/selftest.c: At top level:
drivers/of/selftest.c:129:20: warning: 'of_selftest_property_string' defined but not used [-Wunused-function]
  static void __init of_selftest_property_string(void)
                     ^

Not surprising, since commit 'of: Fix overflow bug in string property
parsing functions' replaces the now missing function with the defined
but unused function, apparently without changing the caller.
Oddly enough, the referenced upstream commit _does_ replace the
function name for both caller and callee.

Guenter

