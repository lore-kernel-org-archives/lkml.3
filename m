Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaCFUXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:23:16 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:37755 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaCFUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:23:14 -0500
X-AuditID: cbfec37c-b7f536d0000059f2-f7-5318d930b280
Message-id: <5318D92D.8020601@samsung.com>
Date: Thu, 06 Mar 2014 13:23:09 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: John de la Garza <john@jjdev.com>, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH] usbip:vhci_sysfs.c: check return value of sscanf
References: <20140306183631.GA31595@vega.jjdev.com>
In-reply-to: <20140306183631.GA31595@vega.jjdev.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9hP12DmxLBBhdny1g0L17PZtE5dR67
	xeVdc9gcmD0mzLrJ6rF/7hp2j8+b5AKYo7hsUlJzMstSi/TtErgymr/fZC74xl1x+8Fb5gbG
	g5xdjJwcEgImEtuW/2eGsMUkLtxbz9bFyMUhJLCMUeLksm/MEE4vk8SrX43sEM4GRolHK9+C
	tfAKaEl8mfORDcRmEVCVeHKqHyzOJqAu8fn1DnYQW0hATqJpyWqwuKhAhMSrsxNZIHoFJX5M
	vgdmiwg4Syzp+QJmMws4SvxecA3MFhZwlbh7YTYbxBxjiZ1rZ4HZnEBnd/y8wwxRby2xctI2
	RghbXmLzGojbhASUJf5cPsXUxcgB9JqCxNcehwmMIrOQbJ6FpHsWku4FjMyrGMVKi5MLipPS
	UyuM9YoTc4tL89L1kvNzNzFCoqFmB+O9rzaHGAU4GJV4eA0WSAQLsSaWFVfmHmKU4GBWEuE1
	PggU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFi6zvxM+AYus6SfL1x3JmSfFg5c8T58p8oUFTXb
	Jcd/ztyUmWDy8E6dxezVTznun7N5pJgsu/TGmRmm67TKMs5Wn2Htmf2l7fzLtUFldlp7zvj5
	5bo4rdy26qCtyYsrGxz4rUSYJ5p+T+m8mzItNKky8sSuZZ4mosz/rZ5VfDA8o3onxT+Sh0eJ
	pTgj0VCLuag4EQAuaTbIZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 11:36 AM, John de la Garza wrote:
> Added code to check return value of sscanf.
>
> Signed-off-by: John de la Garza <john@jjdev.com>
> ---
>   drivers/staging/usbip/vhci_sysfs.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/staging/usbip/vhci_sysfs.c
> index 03e6edf..82dd49f 100644
> --- a/drivers/staging/usbip/vhci_sysfs.c
> +++ b/drivers/staging/usbip/vhci_sysfs.c
> @@ -114,7 +114,8 @@ static ssize_t store_detach(struct device *dev, struct device_attribute *attr,
>   	int err;
>   	__u32 rhport = 0;
>
> -	sscanf(buf, "%u", &rhport);
> +	if (sscanf(buf, "%u", &rhport) != 1)
> +		return -EINVAL;
>
>   	/* check rhport */
>   	if (rhport >= VHCI_NPORTS) {
> @@ -182,7 +183,8 @@ static ssize_t store_attach(struct device *dev, struct device_attribute *attr,
>   	 * @devid: unique device identifier in a remote host
>   	 * @speed: usb device speed in a remote host
>   	 */
> -	sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed);
> +	if (sscanf(buf, "%u %u %u %u", &rhport, &sockfd, &devid, &speed) != 1)
> +		return -EINVAL;
>
>   	usbip_dbg_vhci_sysfs("rhport(%u) sockfd(%u) devid(%u) speed(%u)\n",
>   			     rhport, sockfd, devid, speed);
>

Looks good to me.

Reviewed-by: Shuah Khan <shuah.kh@samsung.com>

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
