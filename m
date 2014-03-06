Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaCFVL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:11:59 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:36676 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaCFVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:11:56 -0500
X-AuditID: cbfec37b-b7f8f6d000007030-96-5318e49be8bd
Message-id: <5318E498.2090800@samsung.com>
Date: Thu, 06 Mar 2014 14:11:52 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Valentina Manea <valentina.manea.m@gmail.com>, gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        ihadzic@research.bell-labs.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        firefly@lists.rosedu.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 05/12] staging: usbip: userspace: re-add interface
 information listing
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-6-git-send-email-valentina.manea.m@gmail.com>
In-reply-to: <1393960252-21247-6-git-send-email-valentina.manea.m@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+wr+7sJxLBBufWa1vsOfOL3aJ5rbjF
	qx0vWCyaF69ns7hwN9Li8q45bBaLlrUyWzy7lmOx5+k7Fot3l+ayO3B5LLlwh8nj3r7DLB7n
	22ezeOycdZfdY//cNewe99o2M3o8XXaD0ePzJrkAjigum5TUnMyy1CJ9uwSujEtPFrMXXJaq
	+H8rq4FxtmgXIyeHhICJxM9ly1kgbDGJC/fWs3UxcnEICSxjlLixuwMsISTQyyTxd5kFRGID
	o0RD9xpGkASvgJbErZ1dYDaLgKpE0+0VrCA2m4C6xOfXO9ghmuUkmpasZgaxRQUiJF6dncgC
	0Sso8WPyPTBbRMBX4v+E3YwgC5gF/jNKTLuxB2yosECMxLQdXSwQm3sZJXbe+cwEkuAU8JE4
	9mEVWDezgLXEyknbGCFseYnNa94yQ2xWlvhz+RRQPQfQbwoSX3scJjCKzEKyexaS7llIuhcw
	Mq9iFCstTi4oTkpPrTDSK07MLS7NS9dLzs/dxAiJv+odjHe/2hxiFOBgVOLhNVggESzEmlhW
	XJl7iFGCg1lJhNf4IFCINyWxsiq1KD++qDQntfgQIxMHp1QDY6DpjGj2ypIvns1trY0qmtwm
	87iP/dnnIfb4RfKUvDPT5+0u9PLvX/zt+dMNT+XYVPWuzjbZcz2N8TbDzQNb2D818J0tWxbc
	8lA0OKRrK/eVW9ddr079X3xzx5sO/peVB65fzmr+sSRrQY65ZWvFbjYOuak/3883XyFppOsi
	Lvjn16/nVbkvbiuxFGckGmoxFxUnAgA3tABHnQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 12:10 PM, Valentina Manea wrote:
> This was deleted in the driver conversion patch. It didn't need
> to be deleted; showing more information is ok.
>
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
> ---
>   drivers/staging/usbip/userspace/src/usbip_list.c | 20 +++++++++++++++++++-
>   drivers/staging/usbip/userspace/src/usbipd.c     | 16 +++++++++++++++-
>   2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
> index 2255107..7e1820a 100644
> --- a/drivers/staging/usbip/userspace/src/usbip_list.c
> +++ b/drivers/staging/usbip/userspace/src/usbip_list.c
> @@ -52,8 +52,9 @@ static int get_exported_devices(char *host, int sockfd)
>   	struct op_devlist_reply reply;
>   	uint16_t code = OP_REP_DEVLIST;
>   	struct usbip_usb_device udev;
> +	struct usbip_usb_interface uintf;
>   	unsigned int i;
> -	int rc;
> +	int rc, j;
>
>   	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
>   	if (rc < 0) {
> @@ -103,6 +104,23 @@ static int get_exported_devices(char *host, int sockfd)
>   		printf("%11s: %s\n", "", udev.path);
>   		printf("%11s: %s\n", "", class_name);
>
> +		for (j = 0; j < udev.bNumInterfaces; j++) {
> +			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
> +			if (rc < 0) {
> +				dbg("usbip_net_recv failed: usbip_usb_intf[%d]",
> +						j);

Please use err() instead of dbg() so this error is reported when it 
happens, not just when usbip_use_debug is enabled.

> +
> +				return -1;
> +			}
> +			usbip_net_pack_usb_interface(0, &uintf);
> +
> +			usbip_names_get_class(class_name, sizeof(class_name),
> +					uintf.bInterfaceClass,
> +					uintf.bInterfaceSubClass,
> +					uintf.bInterfaceProtocol);
> +			printf("%11s: %2d - %s\n", "", j, class_name);
> +		}
> +
>   		printf("\n");
>   	}
>
> diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
> index c2b3ced..b2230f7 100644
> --- a/drivers/staging/usbip/userspace/src/usbipd.c
> +++ b/drivers/staging/usbip/userspace/src/usbipd.c
> @@ -159,8 +159,9 @@ static int send_reply_devlist(int connfd)
>   {
>   	struct usbip_exported_device *edev;
>   	struct usbip_usb_device pdu_udev;
> +	struct usbip_usb_interface pdu_uinf;
>   	struct op_devlist_reply reply;
> -	int rc;
> +	int rc, i;
>
>   	reply.ndev = 0;
>   	/* number of exported devices */
> @@ -194,6 +195,19 @@ static int send_reply_devlist(int connfd)
>   			dbg("usbip_net_send failed: pdu_udev");

Same comment as above.

>   			return -1;
>   		}
> +
> +		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
> +			dump_usb_interface(&edev->uinf[i]);
> +			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
> +			usbip_net_pack_usb_interface(1, &pdu_uinf);
> +
> +			rc = usbip_net_send(connfd, &pdu_uinf,
> +					sizeof(pdu_uinf));
> +			if (rc < 0) {
> +				dbg("usbip_net_send failed: pdu_uinf");

Same comment as above.

> +				return -1;
> +			}
> +		}
>   	}
>
>   	return 0;
>

You have my Reviewed-by after making the recommended changes.

Reviewed-by: Shuah Khan <shuah.kh@samsung.com>

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
