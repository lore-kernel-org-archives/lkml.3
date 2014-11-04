Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaKDMlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:41:15 -0500
Received: from canardo.mork.no ([148.122.252.1]:38655 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbaKDMlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:41:10 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Matthias Klein <matthias.klein@linux.com>
Cc: Lars Melin <larsm17@gmail.com>, johan@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: option: Add ID for Peiker LTE NAD
Organization: m
References: <1414857669-1292-1-git-send-email-matthias.klein@linux.com>
	<5455A676.2080305@gmail.com> <54564E3D.60806@linux.com>
Date: Tue, 04 Nov 2014 13:40:50 +0100
In-Reply-To: <54564E3D.60806@linux.com> (Matthias Klein's message of "Sun, 02
	Nov 2014 16:31:09 +0100")
Message-ID: <87389zdtpp.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (canardo.mork.no [IPv6:2001:4641::1]); Tue, 04 Nov 2014 13:40:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Klein <matthias.klein@linux.com> writes:
> Am 02.11.2014 um 04:35 schrieb Lars Melin:
>> On 2014-11-01 23:01, Matthias Klein wrote:
>>> Add ID of the Peiker LTE NAD for legacy serial interface
>>>
>>> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
>>> ---
>>>   drivers/usb/serial/option.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
>>> index d1a3f60..d7f1042 100644
>>> --- a/drivers/usb/serial/option.c
>>> +++ b/drivers/usb/serial/option.c
>>> @@ -1091,6 +1091,7 @@ static const struct usb_device_id option_ids[] = {
>>>       { USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE
>>> MF330 */
>>>       { USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
>>>       { USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
>>> +    { USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9025)}, /* Peiker LTE NAD */
>>>       { USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6001) },
>>>       { USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_CMU_300) },
>>>       { USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6003),
>> 05c6:9025 already has its net interface (#4) supported by the
>> qmi_wwan driver so your patch is wrong.
>> There is also an ADB interface which I don't think should be driven
>> by option.
>>
>>
> The ID is right, and it can be used with the option driver or qmi_wwan.
> Ignore my patch, I will move to qmi_wwan in the future ...

The serial functions should still be supported by the option driver.
Both serial and QMI can be used at the same time, and applications like
ModemManager will take advantage of this.

What you need to to is to make sure the option driver ignores all the
USB interfaces it cannot handle.  How to best do that depends on the
descriptors - specifically which class codes they use.

"lsusb -vd 05c6:9025" should tell you more about that.

Assuming that all serial interfaces and the QMI interface all use
ff/ff/ff, while the ADB interface probably use ff/42/01, then something
like this should work:


        { USB_DEVICE_AND_INTERFACE_INFO(QUALCOMM_VENDOR_ID, 0x9025, 0xff, 0xff, 0xff), /* Peiker LTE NAD */
          .driver_info = (kernel_ulong_t)&net_intf4_blacklist },



Bjørn
