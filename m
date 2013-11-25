Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3KYPmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:42:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3KYPmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:42:13 -0500
Message-ID: <52936FC5.3060905@redhat.com>
Date: Mon, 25 Nov 2013 10:41:57 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
CC: Jean Delvare <khali@linux-fr.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jerome Blin <jerome.blin@intel.com>
Subject: Re: [PATCH] HID: i2c-hid: disable interrupt on suspend
References: <1384342458-5551-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1384342458-5551-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/13 06:34, Mika Westerberg wrote:
> When an I2C HID device is powered of during system sleep, as a result of
> removing its power resources (by the ACPI core) the interrupt line might go
> low as well. This results inadvertent interrupt and wakes the system from
> sleep immediately.
> 
> To prevent this we disable the device interrupt in the drivers suspend
> method and enable it on resume. The device can still wake the system up if
> it is wake capable (this also means that not all of its power will be
> removed to keep the interrupt line high).
> 
> Reported-by: Jerome Blin <jerome.blin@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---

Jiri, just FYI, I still do not have any final consumer ready i2c-hid
hardware. So I can not test/debug anything related to the suspend-resume.

If Mika tested it properly (which I expect), you may consider pulling
this one.

Cheers,
Benjamin
