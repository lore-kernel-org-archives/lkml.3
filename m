Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaF2TRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 15:17:25 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:54847 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaF2TRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 15:17:24 -0400
Message-ID: <53B0663B.9080806@iki.fi>
Date: Sun, 29 Jun 2014 22:17:15 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Anil Belur <askb23@gmail.com>, m.chehab@samsung.com,
        gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: media: msi3101: sdr-msi3101.c - replace
 with time_before_eq()
References: <1404019216-4726-1-git-send-email-askb23@gmail.com>
In-Reply-To: <1404019216-4726-1-git-send-email-askb23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.185.162
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moikka!
That is already fixed by someone else and patch is somewhere Mauro or 
Hans queue.

regards
Antti

On 06/29/2014 08:20 AM, Anil Belur wrote:
> From: Anil Belur <askb23@gmail.com>
>
> - this fix replaces jiffies interval comparision with safer function to
>    avoid any overflow and wrap around ?
>
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
>   drivers/staging/media/msi3101/sdr-msi3101.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
> index 08d0d09..b828857 100644
> --- a/drivers/staging/media/msi3101/sdr-msi3101.c
> +++ b/drivers/staging/media/msi3101/sdr-msi3101.c
> @@ -180,6 +180,7 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
>   {
>   	int i, i_max, dst_len = 0;
>   	u32 sample_num[3];
> +	unsigned long expires;
>
>   	/* There could be 1-3 1024 bytes URB frames */
>   	i_max = src_len / 1024;
> @@ -208,7 +209,8 @@ static int msi3101_convert_stream_504(struct msi3101_state *s, u8 *dst,
>   	}
>
>   	/* calculate samping rate and output it in 10 seconds intervals */
> -	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> +	expires = s->jiffies_next + msecs_to_jiffies(10000);
> +	if (time_before_eq(expires, jiffies)) {
>   		unsigned long jiffies_now = jiffies;
>   		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
>   		unsigned int samples = sample_num[i_max - 1] - s->sample;
> @@ -332,6 +334,7 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
>   {
>   	int i, i_max, dst_len = 0;
>   	u32 sample_num[3];
> +	unsigned long expires;
>
>   	/* There could be 1-3 1024 bytes URB frames */
>   	i_max = src_len / 1024;
> @@ -360,7 +363,8 @@ static int msi3101_convert_stream_384(struct msi3101_state *s, u8 *dst,
>   	}
>
>   	/* calculate samping rate and output it in 10 seconds intervals */
> -	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> +	expires = s->jiffies_next + msecs_to_jiffies(10000);
> +	if (time_before_eq(expires, jiffies)) {
>   		unsigned long jiffies_now = jiffies;
>   		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
>   		unsigned int samples = sample_num[i_max - 1] - s->sample;
> @@ -397,6 +401,7 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
>   {
>   	int i, i_max, dst_len = 0;
>   	u32 sample_num[3];
> +	unsigned long expires;
>
>   	/* There could be 1-3 1024 bytes URB frames */
>   	i_max = src_len / 1024;
> @@ -425,7 +430,8 @@ static int msi3101_convert_stream_336(struct msi3101_state *s, u8 *dst,
>   	}
>
>   	/* calculate samping rate and output it in 10 seconds intervals */
> -	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> +	expires = s->jiffies_next + msecs_to_jiffies(10000);
> +	if (time_before_eq(expires, jiffies)) {
>   		unsigned long jiffies_now = jiffies;
>   		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
>   		unsigned int samples = sample_num[i_max - 1] - s->sample;
> @@ -460,6 +466,7 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
>   {
>   	int i, i_max, dst_len = 0;
>   	u32 sample_num[3];
> +	unsigned long expires;
>
>   	/* There could be 1-3 1024 bytes URB frames */
>   	i_max = src_len / 1024;
> @@ -488,7 +495,8 @@ static int msi3101_convert_stream_252(struct msi3101_state *s, u8 *dst,
>   	}
>
>   	/* calculate samping rate and output it in 10 seconds intervals */
> -	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {
> +	expires = s->jiffies_next + msecs_to_jiffies(10000);
> +	if (time_before_eq(expires, jiffies)) {
>   		unsigned long jiffies_now = jiffies;
>   		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);
>   		unsigned int samples = sample_num[i_max - 1] - s->sample;
>

-- 
http://palosaari.fi/
