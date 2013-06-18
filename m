Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3FRCmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 22:42:12 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46443 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3FRCmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 22:42:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130617203948.GA32731@kroah.com>
References: <1370452543-19014-1-git-send-email-yhchen@faraday-tech.com>
	<20130617203948.GA32731@kroah.com>
Date: Tue, 18 Jun 2013 10:42:09 +0800
Message-ID: <CADB-GoK7Ntv0yM8hWLE7nrdiLq-fZymyHihGuu-78j4qiDCszA@mail.gmail.com>
Subject: Re: [PATCH] usb: host: Faraday fotg210-hcd driver
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        Alan Stern <stern@rowland.harvard.edu>, sarah.a.sharp@linux.intel.com,
        Felipe Balbi <balbi@ti.com>, florian@openwrt.org,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        ratbert <ratbert.chuang@gmail.com>,
        =?UTF-8?B?Sm9obiBGZW5nLUhzaW4gQ2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 18, 2013 at 4:39 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 05, 2013 at 05:15:43PM +0000, Yuan-Hsin Chen wrote:
>> FOTG210 is an OTG controller which can be configured as an
>> USB2.0 host. FOTG210 host is an ehci-like controller with
>> some differences. First, register layout of FOTG210 is
>> incompatible with EHCI. Furthermore, FOTG210 is lack of
>> siTDs which means iTDs are used for both HS and FS ISO
>> transfer.
>>
>> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>> ---
>>  drivers/usb/Makefile           |    1 +
>>  drivers/usb/host/Kconfig       |   12 +
>>  drivers/usb/host/Makefile      |    1 +
>>  drivers/usb/host/fotg210-hcd.c | 5967 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/usb/host/fotg210.h     |  746 +++++
>>  5 files changed, 6727 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/usb/host/fotg210-hcd.c
>>  create mode 100644 drivers/usb/host/fotg210.h
>
> You obviously didn't even run this through checkpatch.pl, did you?
>
> $ ./scripts/checkpatch.pl --terse ../usb.mbox | tail -n 1
> total: 138 errors, 618 warnings, 6742 lines checked
>
> Please fix all of these if you wish us to at least start reviewing the
> patch.  Your internal Q/A should have caught this first, please be more
> careful in the future.
>

Actually I did run checkpatch.pl and found that almost all errors and
warnings are from ehci core (ehci-hcd.c, ehci-hub.c and so on) where
my driver borrowed most of code.

$ ./scripts/checkpatch.pl --terse -f drivers/usb/host/ehci-hub.c | tail -n 1
total: 18 errors, 69 warnings, 1138 lines checked

$ ./scripts/checkpatch.pl --terse -f drivers/usb/host/ehci-hcd.c | tail -n 1
total: 17 errors, 78 warnings, 1403 lines checked

So you're saying that I should fix them, is that right?

thanks,

Yuan-Hsin

> thanks,
>
> greg k-h
