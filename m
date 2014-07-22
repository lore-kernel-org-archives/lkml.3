Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaGVU4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:56:09 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34272 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbaGVU4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:56:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140722193350.GA486@home.goodmis.org>
References: <1406004789-9918-1-git-send-email-xerofoify@gmail.com>
	<874my98p6u.fsf@nemi.mork.no>
	<CA+8MBb+fnCNeQtyEqttxbkWx-4N+GUaKCUoCSdn5X9+bDDvTOg@mail.gmail.com>
	<CAPDOMVjaf+vne4vbUPo8EPs0XnQBbNm2ZOXns8fw5pkg9tRSww@mail.gmail.com>
	<CAAsK9AGtdJiz0xnmfqLBAqxmt=r+WANsmxwB_vQ3O5aKzMW1LQ@mail.gmail.com>
	<CAPDOMVhj72TFKbtw_93juX19WVdfUzh3KM9tCEjbTdUZvUfcUQ@mail.gmail.com>
	<20140722193350.GA486@home.goodmis.org>
Date: Tue, 22 Jul 2014 16:56:06 -0400
Message-ID: <CAPDOMVipLiXuYqndO_gnMYocDLVsHX9zcTdSMUV_EjJo72nx6w@mail.gmail.com>
Subject: Re: [PATCH] edac: Remove fixmes in e7xxx_edac.c
From: Nick Krause <xerofoify@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Levente Kurusa <lkurusa@redhat.com>, Tony Luck <tony.luck@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 3:33 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, Jul 22, 2014 at 02:25:24PM -0400, Nick Krause wrote:
>>
>> I understand what your saying and I should have searched for Page shift.
>> In addition I am already got commits in the kernel for fix mes so I feel
>> that your comment on fix mes is incorrect.
>
> After seeing your other solutions to "fix mes" around the kernel, I now have to
> investigate the patches that were accepted, and see if they did not cause
> any new bugs. If any of them do, I will ask to have all your patches reverted.
>
> You are not helping. You are actually doing quite the opposite. Who do you work
> for? Microsoft or Apple?
>
> -- Steve
>

I don't work for any companies. And here is one of them that has been accepted.
I am removing two fix mes in this file as after dicussing then it  seems
there is no reason to check against Null for usb_device as it can never
be NULL and this is check is therefore not needed.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/usb/core/hcd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index bec31e2..487abcf 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -855,8 +855,6 @@ static ssize_t authorized_default_show(struct device *dev,
        struct usb_bus *usb_bus = rh_usb_dev->bus;
        struct usb_hcd *usb_hcd;

-       if (usb_bus == NULL)    /* FIXME: not sure if this case is possible */
-               return -ENODEV;
        usb_hcd = bus_to_hcd(usb_bus);
        return snprintf(buf, PAGE_SIZE, "%u\n", usb_hcd->authorized_default);
 }
@@ -871,8 +869,6 @@ static ssize_t authorized_default_store(
struct device *dev,
        struct usb_bus *usb_bus = rh_usb_dev->bus;
        struct usb_hcd *usb_hcd;

-       if (usb_bus == NULL)    /* FIXME: not sure if this case is possible */
-               return -ENODEV;
        usb_hcd = bus_to_hcd(usb_bus);
        result = sscanf(buf, "%u\n", &val);
        if (result == 1) {
Nick
