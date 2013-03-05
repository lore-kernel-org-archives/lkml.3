Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3CECSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:18:05 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:37377 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab3CECR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:17:28 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH] USB: storage: fix Huawei mode switching regression
Thread-Topic: [PATCH] USB: storage: fix Huawei mode switching regression
Thread-Index: AQHOGNr0lx41BSLTpUK/JicdprGbMpiWVFvA
Date: Tue, 5 Mar 2013 02:15:31 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
References: <87obezs888.fsf@nemi.mork.no>
 <1362403161-23501-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1362403161-23501-1-git-send-email-bjorn@mork.no>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.145]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r252I7Kn004912



> -----Original Message-----
> From: BjÃ¸rn Mork [mailto:bjorn@mork.no]
> Sent: Monday, March 04, 2013 9:19 PM
> To: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Fangxiaozhi (Franko); Xueguiying (Zihan);
> Linlei (Lei Lin); Greg KH; Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C);
> balbi@ti.com; mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc;
> BjÃ¸rn Mork; stable
> Subject: [PATCH] USB: storage: fix Huawei mode switching regression
> 
> This reverts commit 200e0d99 ("USB: storage: optimize to match the Huawei
> USB storage devices and support new switch command" and the followup
> bugfix commit cd060956 ("USB: storage: properly handle the endian issues of
> idProduct").
> 
> The commit effectively added a large number of Huawei devices to the
> deprecated usb-storage mode switching logic.  Many of these devices have
> been in use and supported by the userspace usb_modeswitch utility for years.
> Forcing the switching inside the kernel causes a number of regressions as a
> result of ignoring existing onfigurations, and also completely takes away the
> ability to configure mode switching per device/system/user.
------ commit 200e0d99 and commit cd060956, only put the switch command into kernel, instead of userspace usb_modeswitch utility. 
------ Because in the embedded linux system, Android, or Chrome OS, etc. They don't integrate userspace usb_modeswitch utility for switching.
----- In commit 200e0d99, we send the Linux switching command to Huawei devices, so on PC Linux, you can get the largest capacity of Huawei device, including the CDROM feature. So I think this solution can meet the user's requirement in Linux.

> 
> Known regressions caused by this:
>  - Some of the devices support multiple modes, using different
>   switching commands.  There are existing configurations taking
>   advantage of this.
-------But in this multiple modes, there is only one is for Linux. We don't advice the user to use the other mode not for Linux. It may cause some unexpected problem.
> 
>  - There is a real use case for disabling mode switching and
>   instead mounting the exposed storage device. This becomes
>   impossible with switching logic inside the usb-storage driver.
----In commit 200e0d99, the switching command will ask Huawei device to offer the CDROM(and /or SD) port together. After switching, users also can get the mounting storage device.
> 
>  - At least on device fail as a result of the usb-storage switching
>   command, becoming completely unswitchable. This is possibly a
>   firmware bug, but still a regression because the device work as
>   expected using usb_modeswitch defaults.
----- If the kernel solution encounters this issue, then it also will occur with usb_modeswitch.

> 
> In-kernel mode switching was deprecated years ago with the development of
> the more user friendly userspace alternatives. The existing list of devices in
> usb-storage was only kept to prevent breaking already working systems.  The
> long term plan is to remove the list, not to add to it. Ref:
> http://permalink.gmane.org/gmane.linux.usb.general/28543
> 
> Cc: <fangxiaozhi@huawei.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: BjÃ¸rn Mork <bjorn@mork.no>
> ---
> I just realized that this already had gone into maintained stable series', making
> the fix so much more urgent.  This needs to be reverted before it starts
> hitting innocent distro users.  So I am sending the patch now instead of
> waiting for Huawei to respond.
------ In our opinions, it is better to switch Huawei device in kernel. 
------ usb_modeswitch is a tool for Linux. 
------ We can not guarantee it will be integrated in all the system which integrates linux kernel. But linux kernel itself can.

> 
> 
> BjÃ¸rn
> 

Best Regards,
Franko Fang

>  drivers/usb/storage/initializers.c |   76 +--------
>  drivers/usb/storage/initializers.h |    4 +-
>  drivers/usb/storage/unusual_devs.h |  329
> +++++++++++++++++++++++++++++++++++-
>  3 files changed, 331 insertions(+), 78 deletions(-)
> 
> diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
> index 7ab9046..105d900 100644
> --- a/drivers/usb/storage/initializers.c
> +++ b/drivers/usb/storage/initializers.c
> @@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
>  	return 0;
>  }
> 
> -/* This places the HUAWEI usb dongles in multi-port mode */ -static int
> usb_stor_huawei_feature_init(struct us_data *us)
> +/* This places the HUAWEI E220 devices in multi-port mode */ int
> +usb_stor_huawei_e220_init(struct us_data *us)
>  {
>  	int result;
> 
> @@ -104,75 +104,3 @@ static int usb_stor_huawei_feature_init(struct
> us_data *us)
>  	US_DEBUGP("Huawei mode set result is %d\n", result);
>  	return 0;
>  }
> -
> -/*
> - * It will send a scsi switch command called rewind' to huawei dongle.
> - * When the dongle receives this command at the first time,
> - * it will reboot immediately. After rebooted, it will ignore this command.
> - * So it is  unnecessary to read its response.
> - */
> -static int usb_stor_huawei_scsi_init(struct us_data *us) -{
> -	int result = 0;
> -	int act_len = 0;
> -	struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
> -	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> -			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> -
> -	bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
> -	bcbw->Tag = 0;
> -	bcbw->DataTransferLength = 0;
> -	bcbw->Flags = bcbw->Lun = 0;
> -	bcbw->Length = sizeof(rewind_cmd);
> -	memset(bcbw->CDB, 0, sizeof(bcbw->CDB));
> -	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
> -
> -	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcbw,
> -					US_BULK_CB_WRAP_LEN, &act_len);
> -	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
> -	return result;
> -}
> -
> -/*
> - * It tries to find the supported Huawei USB dongles.
> - * In Huawei, they assign the following product IDs
> - * for all of their mobile broadband dongles,
> - * including the new dongles in the future.
> - * So if the product ID is not included in this list,
> - * it means it is not Huawei's mobile broadband dongles.
> - */
> -static int usb_stor_huawei_dongles_pid(struct us_data *us) -{
> -	struct usb_interface_descriptor *idesc;
> -	int idProduct;
> -
> -	idesc = &us->pusb_intf->cur_altsetting->desc;
> -	idProduct = le16_to_cpu(us->pusb_dev->descriptor.idProduct);
> -	/* The first port is CDROM,
> -	 * means the dongle in the single port mode,
> -	 * and a switch command is required to be sent. */
> -	if (idesc && idesc->bInterfaceNumber == 0) {
> -		if ((idProduct == 0x1001)
> -			|| (idProduct == 0x1003)
> -			|| (idProduct == 0x1004)
> -			|| (idProduct >= 0x1401 && idProduct <= 0x1500)
> -			|| (idProduct >= 0x1505 && idProduct <= 0x1600)
> -			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
> -			return 1;
> -		}
> -	}
> -	return 0;
> -}
> -
> -int usb_stor_huawei_init(struct us_data *us) -{
> -	int result = 0;
> -
> -	if (usb_stor_huawei_dongles_pid(us)) {
> -		if (le16_to_cpu(us->pusb_dev->descriptor.idProduct) >= 0x1446)
> -			result = usb_stor_huawei_scsi_init(us);
> -		else
> -			result = usb_stor_huawei_feature_init(us);
> -	}
> -	return result;
> -}
> diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initializers.h
> index 5376d4f..529327f 100644
> --- a/drivers/usb/storage/initializers.h
> +++ b/drivers/usb/storage/initializers.h
> @@ -46,5 +46,5 @@ int usb_stor_euscsi_init(struct us_data *us);
>   * flash reader */
>  int usb_stor_ucr61s2b_init(struct us_data *us);
> 
> -/* This places the HUAWEI usb dongles in multi-port mode */ -int
> usb_stor_huawei_init(struct us_data *us);
> +/* This places the HUAWEI E220 devices in multi-port mode */ int
> +usb_stor_huawei_e220_init(struct us_data *us);
> diff --git a/drivers/usb/storage/unusual_devs.h
> b/drivers/usb/storage/unusual_devs.h
> index 72923b5..d305a5a 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1527,10 +1527,335 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100,
> 0x0100,
>  /* Reported by fangxiaozhi <huananhu@huawei.com>
>   * This brings the HUAWEI data card devices into multi-port mode
>   */
> -UNUSUAL_VENDOR_INTF(0x12d1, 0x08, 0x06, 0x50,
> +UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
> -		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_init,
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1003, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1004, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1401, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1402, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1403, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1404, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1405, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1406, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1407, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1408, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1409, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x140A, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x140B, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x140C, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x140D, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x140E, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x140F, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1410, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1411, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1412, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1413, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1414, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1415, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1416, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1417, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1418, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1419, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x141A, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x141B, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x141C, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x141D, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x141E, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x141F, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1420, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1421, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1422, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1423, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1424, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1425, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1426, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1427, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1428, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1429, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x142A, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x142B, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x142C, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x142D, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x142E, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x142F, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1430, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1431, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1432, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1433, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1434, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1435, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1436, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1437, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1438, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x1439, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x143A, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x143B, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x143C, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x143D, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x143E, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
> +		0),
> +UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
> +		"HUAWEI MOBILE",
> +		"Mass Storage",
> +		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
>  		0),
> 
>  /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
> --
> 1.7.10.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
