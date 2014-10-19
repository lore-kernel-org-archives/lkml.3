Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaJSWIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:08:14 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37166 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaJSWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Oct 2014 15:07:49 -0700
Message-ID: <CALCETrUt8wK+wPULZpPQks3xEB0JkQkUD=peLSnBrMo70LT13w@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, josh.triplett@intel.com,
        christophe.ricard@gmail.com, will.c.arthur@intel.com,
        monty.wiseman@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 4:35 AM, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> Implemented sysfs attributes for TPM2 devices. TPM2 sysfs attributes
> are mounted in the actual device associated with the chip instead of
> platform device like with TPM1 devices.
>
> Documentation/ABI/stable/sysfs-class/tpm2 contains descriptions
> of these attributes.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>


> +What:          /sys/class/misc/tpmX/device/cancel
> +Date:          October 2014
> +KernelVersion: 3.19
> +Contact:       tpmdd-devel@lists.sf.net
> +Description:   The "cancel" property allows you to cancel the currently
> +               pending TPM command. Writing any value to cancel will call the
> +               TPM chip specific cancel operation.

This is weird.  From the POV of a sysfs user, what operation gets
canceled?  What if it's a kernel-internal operation?

Shouldn't this be an ioctl?

--Andy
