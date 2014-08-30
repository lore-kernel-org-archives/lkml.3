Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaH3KgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:36:10 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60815 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaH3KgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:36:07 -0400
Message-ID: <5401A913.6080700@kernel.org>
Date: Sat, 30 Aug 2014 11:36:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-iio@vger.kernel.org
CC: srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] iio: accel: BMC150: fix scale value for 16G
References: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com> <1409301488-22166-2-git-send-email-laurentiu.palcu@intel.com>
In-Reply-To: <1409301488-22166-2-git-send-email-laurentiu.palcu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 09:38, Laurentiu Palcu wrote:
> According to documentation ([1] - page 27), the range for 16G is
> 7.81mg/LSB. Converted to SI, this is:
>     7.81 * 10^-3 * 9.80665 m/s^2 / LSB = 0.0765899365 m/s^2 / LSB
> 
> [1] http://ae-bst.resource.bosch.com/media/products/dokumente/bmc150/BST-BMC150-DS000-04.pdf
> 
> Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
Applied to the togreg branch of iio.git - initially pushed out as testing for the autobuilders
to play.

I could only track down one previous datasheet version and that had the
same value, so perhaps a typo was responsible for this error.

Jonathan
> ---
>  drivers/iio/accel/bmc150-accel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
> index 23ae334..ccb6cf8 100644
> --- a/drivers/iio/accel/bmc150-accel.c
> +++ b/drivers/iio/accel/bmc150-accel.c
> @@ -173,7 +173,7 @@ static const struct {
>  } bmc150_accel_scale_table[] = { {9610, BMC150_ACCEL_DEF_RANGE_2G},
>  				 {19122, BMC150_ACCEL_DEF_RANGE_4G},
>  				 {38344, BMC150_ACCEL_DEF_RANGE_8G},
> -				 {77057, BMC150_ACCEL_DEF_RANGE_16G} };
> +				 {76590, BMC150_ACCEL_DEF_RANGE_16G} };
>  
>  static const struct {
>  	int sleep_dur;
> 
