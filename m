Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3FRAeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:34:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52638 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3FRAd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:33:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130617235915.GA19162@kroah.com>
References: <1371285398-18566-1-git-send-email-ming.lei@canonical.com>
	<20130617235915.GA19162@kroah.com>
Date: Tue, 18 Jun 2013 08:33:55 +0800
Message-ID: <CACVXFVNahZpH-FdZ=NJ1HZybDCSuoV2aZM2--gBVMD22FVBJcQ@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: fix use-after-free by double abort
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: nirinA raseliarison <nirina.raseliarison@gmail.com>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 7:59 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Jun 15, 2013 at 04:36:38PM +0800, Ming Lei wrote:
>> fw_priv->buf is accessed in both request_firmware_load() and
>> writing to sysfs file of 'loading' context, but not protected
>> by 'fw_lock' entirely. The patch makes sure that access on
>> 'fw_priv->buf' is protected by the lock.
>>
>> So fixes the double abort problem reported by nirinA raseliarison:
>>
>>       http://lkml.org/lkml/2013/6/14/188
>>
>> Reported-and-tested-by: nirinA raseliarison <nirina.raseliarison@gmail.com>
>> Cc: Guenter Roeck <linux@roeck-us.net>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: stable <stable@vger.kernel.org>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>
> So this is a 3.9-stable thing?  Anything newer than that?

Yes, only 3.9-stable need this.

Thanks,
--
Ming Lei
