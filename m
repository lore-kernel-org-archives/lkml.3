Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbbATIw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:52:58 -0500
Received: from smtp-out-231.synserver.de ([212.40.185.231]:1077 "EHLO
	smtp-out-231.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbATIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:52:56 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 359
Message-ID: <54BE175D.3070504@metafoo.de>
Date: Tue, 20 Jan 2015 09:52:45 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Asaf Vertz <asaf.vertz@tandemg.com>, gregkh@linuxfoundation.org
CC: Michael.Hennerich@analog.com, jic23@kernel.org, knaack.h@gmx.de,
        pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: ad5933: fix format string warnings
References: <20150120072522.GA3361@ubuntu>
In-Reply-To: <20150120072522.GA3361@ubuntu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 08:25 AM, Asaf Vertz wrote:
> Fixed the following warnings (reported by cppcheck):
> [drivers/staging/iio/impedance-analyzer/ad5933.c:363]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 1)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 2)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 3)
> requires 'int' but the argument type is 'unsigned int'.
> [drivers/staging/iio/impedance-analyzer/ad5933.c:367]: (warning) %d in format string (no. 4)
> requires 'int' but the argument type is 'unsigned int'.
>
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.

> ---
>   drivers/staging/iio/impedance-analyzer/ad5933.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/staging/iio/impedance-analyzer/ad5933.c
> index b6bd609..4230a43 100644
> --- a/drivers/staging/iio/impedance-analyzer/ad5933.c
> +++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
> @@ -360,11 +360,11 @@ static ssize_t ad5933_show(struct device *dev,
>   	mutex_lock(&indio_dev->mlock);
>   	switch ((u32) this_attr->address) {
>   	case AD5933_OUT_RANGE:
> -		len = sprintf(buf, "%d\n",
> +		len = sprintf(buf, "%u\n",
>   			      st->range_avail[(st->ctrl_hb >> 1) & 0x3]);
>   		break;
>   	case AD5933_OUT_RANGE_AVAIL:
> -		len = sprintf(buf, "%d %d %d %d\n", st->range_avail[0],
> +		len = sprintf(buf, "%u %u %u %u\n", st->range_avail[0],
>   			      st->range_avail[3], st->range_avail[2],
>   			      st->range_avail[1]);
>   		break;
>

