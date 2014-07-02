Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaGBDV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:21:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42371 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaGBDV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <1404270473-4285-1-git-send-email-mcgrof@do-not-panic.com>
References: <1404270473-4285-1-git-send-email-mcgrof@do-not-panic.com>
Date: Wed, 2 Jul 2014 11:21:53 +0800
Message-ID: <CACVXFVN=omNO6aL96DU+rp8uF0A84gH3ZPfdLDCR7e_Y207b1Q@mail.gmail.com>
Subject: Re: [PATCH v2] firmware loader: inform direct failure when udev
 loader is disabled
From: Ming Lei <ming.lei@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Tom Gundersen <teg@jklm.no>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 11:07 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> Now that the udev firmware loader is optional request_firmware()
> will not provide any information on the kernel ring buffer if
> direct firmware loading failed and udev firmware loading is disabled.
> If no information is needed request_firmware_direct() should be used
> for optional firmware, at which point drivers can take on the onus
> over informing of any failures, if udev firmware loading is disabled
> though we should at the very least provide some sort of information
> as when the udev loader was enabled by default back in the days.
>
> With this change with a simple firmware load test module [0]:
>
> Example output without FW_LOADER_USER_HELPER_FALLBACK
>
> platform fake-dev.0: Direct firmware load for fake.bin failed
> with error -2
>
> Example with FW_LOADER_USER_HELPER_FALLBACK
>
> platform fake-dev.0: Direct firmware load for fake.bin failed with error -2
> platform fake-dev.0: Falling back to user helper
>
> Without this change without FW_LOADER_USER_HELPER_FALLBACK we
> get no output logged upon failure.
>
> Cc: Tom Gundersen <teg@jklm.no>
> Cc: Ming Lei <ming.lei@canonical.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Abhay Salunke <Abhay_Salunke@dell.com>
> Cc: Stefan Roese <sr@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Looks fine, also it is a cleanup.

Acked-by: Ming Lei <ming.lei@canonical.com>

Thanks,
--
Ming Lei
