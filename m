Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab3HSMkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 08:40:49 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:46292 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab3HSMkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=HjtV/X
	DS6LjQ6O1QBFTa4kQ+APcl2TfOd141BNTTXV4U0lDKQtb2K8v5liBSojz3ancy6b
	HkcWailgaLVbTvxYX7QBMK6GhVWqFDjKLymXjK2fz+UCPUyPzGxFTnCrWeR7eEHm
	6ClSVUjFHvAR1SlT15ehwAYFzBP7Srk1KQPrI=
Message-ID: <52121248.2090000@pobox.com>
Date: Mon, 19 Aug 2013 21:40:40 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mika.westerberg@linux.intel.com
CC: linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        christian.ruppert@abilis.com, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 1/2] i2c-designware: make HCNT/LCNT values configurable
References: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1376914074-31103-1-git-send-email-mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 917AFB70-08CC-11E3-8A06-CA9B8506CD1E-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/13 9:07 PM, Mika Westerberg wrote:
> The DesignWare I2C controller has high count (HCNT) and low count (LCNT)
> registers for each of the I2C speed modes (standard and fast). These
> registers are programmed based on the input clock speed in the driver.
>
> The current code calculates these values based on the input clock speed and
> tries hard to meet the I2C bus timing requirements. This could result
> non-optimal values with regarding to the bus speed. For example on Intel
> BayTrail we get bus speed of 315.41kHz which is ~20% slower than we would
> expect (400kHz) in fast mode (even though the timing requirements are met).
>
> This patch makes it possible for the platform code to pass more optimal
> HCNT/LCNT values to the core driver if they are known beforehand. If these
> are not set we use the calculated and more conservative values.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Looks good, thanks.

Acked-by: Shinya Kuribayashi <skuribay@pobox.com>

