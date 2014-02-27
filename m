Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaB0TPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:15:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:57034 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaB0TPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:15:34 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: John Stultz <john.stultz@linaro.org>
Subject: Re: Fwd: [RFC][PATCH] staging: Fix build issues with new binder API
Date: Thu, 27 Feb 2014 20:15:23 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1393453747-12513-1-git-send-email-john.stultz@linaro.org> <530E6B56.8060405@linaro.org>
In-Reply-To: <530E6B56.8060405@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402272015.24077.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:a7r5iScCg33ANh6LC9pd/psz0vj2KJ4retaoQSeW/l9
 /WBU0XgMvHhg6GQkO/nHt04AZZPoeLo7RrMN4O2OyY+cajIXq5
 BITsntNhTSEX862N2cSZra6qRoOSja+cv2YPYhNx8ZDZg90GgT
 Zf2cIQ1ljk7kkkjKq1kipyhbVP3PJBfPmnK9EAabjIHpku7IZB
 t1WYGutG6KZe7rjnNizyR+FzIzaaEXYblemEFlmWzqO1K3Iwav
 MyiOzoQAnv7jiAS96TGxM5rpyHqMJ4YmUlvHhn1Y1bkr0gweXS
 lPEyhlxSaUkZ/4ut69NnrTfGjs4o4mOCcCjqg+H/6KIVDzAGBH
 c/ZRStEvi3KozA+bK0bPVifR90Oq0juIb/BX2Krpa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, John Stultz wrote:
> The new 64bit binder API causes build issues on 32bit ARM
> due to the lack of 64bit __get_user_asm_* implementation.

It is impossible to implement this. Many have tried before.

> Until that implementation is done, remove the choice for
> 32bit ARM, automatically enabling the old 32bit binder
> protocol.
> 
> This can be reverted once a 64bit __get_user_asm_*
> implementation is merged.

I think the best solution is to use __copy_from_user for
the 64-bit access. You can wrap it in a helper function
if you want to speed up the native-word-size case.

	Arnd
