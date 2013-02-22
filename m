Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3BVPgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:36:54 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:36826 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab3BVPgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:36:51 -0500
Message-ID: <5127908D.5020301@mev.co.uk>
Date: Fri, 22 Feb 2013 15:36:45 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kumar amit mehta <gmate.amit@gmail.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2] staging: comedi: drivers: usbduxsigma.c: fix DMA buffers
 on stack
References: <1361513228-8897-1-git-send-email-gmate.amit@gmail.com> <51274244.6080507@mev.co.uk> <20130222142619.GA11141@gmail.com>
In-Reply-To: <20130222142619.GA11141@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-22 14:26, Kumar amit mehta wrote:
> On Fri, Feb 22, 2013 at 10:02:44AM +0000, Ian Abbott wrote:
>> On 2013-02-22 06:07, Kumar Amit Mehta wrote:
>>> This patch fixes an instance of DMA buffer on stack(being passed to
>>> usb_control_msg)for the USB-DUXsigma Board driver. Found using smatch.
>>>
>>
>> Looks good here too.
>>
>> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
>>
>> Would you mind doing the same for usbdux.c and usbduxfast.c?
> Sure.
> As pointed out by Dan, Do you really want the buffer to be of 16 bytes, as we
> are using only the first byte and passing the length as '1' in:
> usbduxsub_start, usbduxsub_stop, usbduxfastsub_start, usbduxfastsub_stop ?

A buffer size of 1 should be fine.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
