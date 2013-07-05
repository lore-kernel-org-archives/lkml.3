Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778Ab3GEC77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 22:59:59 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36408 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab3GEC75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 22:59:57 -0400
Date: Fri, 5 Jul 2013 10:59:47 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Yang Bai <hamo.by@gmail.com>
Cc: linux-bluetooth@vger.kernel.org,
        Wen-chien Jesse Sung <jesse.sung@canonical.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        "Anthony Wong'" <anthony.wong@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btusb: fix overflow return values
Message-ID: <20130705025947.GA10744@adam-laptop>
Mail-Followup-To: Yang Bai <hamo.by@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Wen-chien Jesse Sung <jesse.sung@canonical.com>,
	AceLan Kao <acelan.kao@canonical.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>,
	Anthony Wong' <anthony.wong@canonical.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	open list <linux-kernel@vger.kernel.org>
References: <1372941783-30657-1-git-send-email-adam.lee@canonical.com>
 <CAO_0yfOXfO1ZNTNbYRnuY-CQ44hH+DqoEB5jnCwfhLPTq-RUqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO_0yfOXfO1ZNTNbYRnuY-CQ44hH+DqoEB5jnCwfhLPTq-RUqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 10:37:07AM +0800, Yang Bai wrote:
> The return value of btusb_setup_intel is compared with 0. Code as:
> 
> drivers/bluetooth/btusb.c:
> static int btusb_probe(struct usb_interface *intf,
> const struct usb_device_id *id)
> if (id->driver_info & BTUSB_INTEL)
> hdev->setup = btusb_setup_intel;
> 
> net/bluetooth/hci_core.c:
> int hci_dev_open(__u16 dev)
> if (hdev->setup && test_bit(HCI_SETUP, &hdev->dev_flags))
> ret = hdev->setup(hdev);
> 
> if (!ret) {

Yes, for btusb_setup_intel(), the return value is compared with number
"0", doesn't break the judgement.

But it still overflows stack without this fix.

> On Thu, Jul 4, 2013 at 8:43 PM, Adam Lee <adam.lee@canonical.com> wrote:
> 
>     PTR_ERR() returns a long type value, but btusb_setup_intel() and
>     btusb_setup_intel_patching() should return an int type value.
>
>     This bug makes the judgement "if (ret < 0)" not working on x86_64
>     architecture systems, leading to failure as below, even panic.

-- 
Regards,
Adam Lee
Hardware Enablement
