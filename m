Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaILWNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:13:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaILWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:13:35 -0400
Date: Fri, 12 Sep 2014 15:13:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Simon Glass <sjg@chromium.org>
Subject: Re: [PATCH RESEND v9 5/5] rtc: Add driver for Maxim 77802 PMIC
 Real-Time-Clock
Message-Id: <20140912151334.cd53fca611a7de487f23241b@linux-foundation.org>
In-Reply-To: <1410509864-10019-6-git-send-email-javier.martinez@collabora.co.uk>
References: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
	<1410509864-10019-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 10:17:43 +0200 Javier Martinez Canillas <javier.martinez@collabora.co.uk> wrote:

> The MAX7802 PMIC has a Real-Time-Clock (RTC) with two alarms.
> This patch adds support for the RTC and is based on a driver
> added by Simon Glass to the Chrome OS kernel 3.8 tree.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Would it be appropriate to gather Simon's signoff?

> +static inline int max77802_rtc_calculate_wday(u8 shifted)
> +{
> +	int counter = -1;
> +
> +	while (shifted) {
> +		shifted >>= 1;
> +		counter++;
> +	}

Can't use log2() or similar?

> +	return counter;
> +}
