Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaLEF5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:57:07 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38823 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaLEF5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:57:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAA7nrtg_G+U2EVxy0joZC+fBGyXS_uOwe1RZ8PyoDv7icu6OBw@mail.gmail.com>
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
	<1417610126-7957-2-git-send-email-harinik@xilinx.com>
	<CAA7nrtg_G+U2EVxy0joZC+fBGyXS_uOwe1RZ8PyoDv7icu6OBw@mail.gmail.com>
Date: Fri, 5 Dec 2014 11:27:01 +0530
Message-ID: <CAFcVECJtMJUAcjLTQ1eP=qBr2Lbf0DUy5dSE7f9UpT8a-9h6yQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] i2c: cadence: Handle > 252 byte transfers
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: rajeev kumar <rajeevkumar.linux@gmail.com>
Cc: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 5, 2014 at 11:11 AM, rajeev kumar
<rajeevkumar.linux@gmail.com> wrote:
> On Wed, Dec 3, 2014 at 6:05 PM, Harini Katakam <harinik@xilinx.com> wrote:
>> The I2C controller sends a NACK to the slave when transfer size register
>> reaches zero, irrespective of the hold bit. So, in order to handle transfers
>> greater than 252 bytes, the transfer size register has to be maintained at a
>> value >= 1. This patch implements the same.
>
> Why 252 Bytes ?  Is it word allign or what ?
>

It is the maximum transfer size that can be written that is a multiple of
the data interrupt (this occurs when the fifo has 14 bytes).
I will include an explanation in driver as well.

Regards,
Harini
