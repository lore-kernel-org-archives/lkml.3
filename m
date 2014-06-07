Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaFGKod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 06:44:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:55325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbaFGKoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 06:44:32 -0400
Message-ID: <5392ED7E.7060201@kernel.org>
Date: Sat, 07 Jun 2014 11:46:22 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/iio: IIO_SIMPLE_DUMMY_BUFFER neds IIO_BUFFER
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de> <1402001295-1980118-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1402001295-1980118-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/14 21:48, Arnd Bergmann wrote:
> An obviously missing 'select' statement, without this we
> get a link error
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: linux-iio@vger.kernel.org
Applied to the fixes-togreg branch of iio.git

Thanks,

Jonathan
> ---
>   drivers/staging/iio/Kconfig | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
> index b36feb0..fa38be0 100644
> --- a/drivers/staging/iio/Kconfig
> +++ b/drivers/staging/iio/Kconfig
> @@ -36,10 +36,11 @@ config IIO_SIMPLE_DUMMY_EVENTS
>            Add some dummy events to the simple dummy driver.
>
>   config IIO_SIMPLE_DUMMY_BUFFER
> -       boolean "Buffered capture support"
> -       select IIO_KFIFO_BUF
> -       help
> -         Add buffered data capture to the simple dummy driver.
> +	boolean "Buffered capture support"
> +	select IIO_BUFFER
> +	select IIO_KFIFO_BUF
> +	help
> +	  Add buffered data capture to the simple dummy driver.
>
>   endif # IIO_SIMPLE_DUMMY
>
>

