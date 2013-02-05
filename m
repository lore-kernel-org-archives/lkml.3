Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3BECyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:54:04 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41817 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3BECyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:54:02 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r152rF8U020185
Message-ID: <511073C5.9040300@realtek.com>
Date: Tue, 5 Feb 2013 10:51:49 +0800
From: Roger Tseng <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        "cjb@laptop.org" <cjb@laptop.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH 1/3] MMC: rtsx: remove driving adjustment
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com> <1359963959-2305-2-git-send-email-rogerable@realtek.com> <20130204084737.GG4937@mwanda>
In-Reply-To: <20130204084737.GG4937@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Correct. I will prevent this kind of breaking in the future.

However, after our analysis the breaking of patch 1/3 and 2/3 should not 
fail old devices. And since Samuel has applied 2/3 and 3/3, it might be 
better for Chris to apply patch 1/3 and let all this things appear in 
kernel v3.9.

Hi Chris,

Would you please apply patch 1/3 for kernel v3.9. Thanks.

Best regards,
Roger Tseng

On 02/04/2013 04:47 PM, Dan Carpenter wrote:
> On Mon, Feb 04, 2013 at 03:45:57PM +0800, Roger Tseng wrote:
>> Several new models of readers use different way to select driving
>> capability(a necessary adjustment along with voltage change). Removing this
>> from device-independent rtsx_pci_sdmmc module. It will be implemented in
>> device-depend calls encapsulated by rtsx_pci_switch_output_voltage().
>>
>
> I'm not sure I understand.
>
> Does this patch break things and then "[PATCH 2/3] mfd: rtsx:
> implement driving adjustment to device-dependent callbacks" fixes
> things again?  In other words, will all the old devices run if we
> only apply patch 1/3 and not 2/3?
>
> That's not the right idea.  Just merge the two patches into one
> patch.
>
> regards,
> dan carpenter
>
>
> ------Please consider the environment before printing this e-mail.
>
>
