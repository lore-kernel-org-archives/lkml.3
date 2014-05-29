Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaEaKDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 06:03:35 -0400
Received: from mail.kernel.org ([198.145.19.201]:45772 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaEaKDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 06:03:33 -0400
Message-ID: <53876477.7000503@kernel.org>
Date: Thu, 29 May 2014 17:46:47 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH 1/3] IIO: Add iio magn_north ABI documentation
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com> <1401311175-12784-2-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1401311175-12784-2-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/14 22:06, Reyad Attiyat wrote:
> Update documentation for HID compass true/magnetic north sensor.
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> ---
>   Documentation/ABI/testing/sysfs-bus-iio | 76 +++++++++++++++++++++++++++++++++
>   1 file changed, 76 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 6e02c50..0341b2f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -165,6 +165,10 @@ Description:
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_raw
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_raw
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_raw
Hmm. The question to my mind is whether people would expect a simple north to give
them which direction north is?
Also is it actually relevant whether they find north from a magnetometer or some other method?
I wonder if we want to make these some sort of north referenced rotation?
in_rot_from_true_north_raw
in_rot_from_magnetic_north_raw

Technically it is possible to get some direction information from some GPS receivers or to
to maintain a knowledge of its location with good gyroscopes.

Ultimately userspace doesn't care about it.  When we were using the axial magnetic functions we
were measuring the field magnitude in that direction. As I understand it here it is just an angle?

J
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_tilt_comp_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_tilt_comp_raw
>   KernelVersion:	2.6.35
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -249,6 +253,10 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_tilt_comp_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_magn_north_true_tilt_comp_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
>   KernelVersion:	2.6.35
> @@ -436,6 +444,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_thresh_rising_en
> @@ -481,6 +497,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_y_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_tilt_comp_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_magn_north_true_tilt_comp_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_roc_rising_en
> @@ -527,6 +551,14 @@ What:		/sys/.../events/in_magn_y_raw_thresh_rising_value
>   What:		/sys/.../events/in_magn_y_raw_thresh_falling_value
>   What:		/sys/.../events/in_magn_z_raw_thresh_rising_value
>   What:		/sys/.../events/in_magn_z_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_true_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_true_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_tilt_comp_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_tilt_comp_raw_thresh_falling_value
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_thresh_rising_value
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_thresh_falling_value
>   What:		/sys/.../events/in_voltageY_supply_raw_thresh_rising_value
>   What:		/sys/.../events/in_voltageY_supply_raw_thresh_falling_value
>   What:		/sys/.../events/in_voltageY_raw_thresh_rising_value
> @@ -577,6 +609,18 @@ What:		/sys/.../events/in_magn_y_thresh_either_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_rising_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_falling_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_true_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_true_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_true_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_tilt_comp_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_tilt_comp_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_tilt_comp_thresh_either_hysteresis
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_rising_hysteresis
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_falling_hysteresis
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_either_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_rising_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_falling_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_either_hysteresis
> @@ -624,6 +668,14 @@ What:		/sys/.../events/in_magn_y_raw_roc_rising_value
>   What:		/sys/.../events/in_magn_y_raw_roc_falling_value
>   What:		/sys/.../events/in_magn_z_raw_roc_rising_value
>   What:		/sys/.../events/in_magn_z_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_true_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_true_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_tilt_comp_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_tilt_comp_raw_roc_falling_value
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_roc_rising_value
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_raw_roc_falling_value
>   What:		/sys/.../events/in_voltageY_supply_raw_roc_rising_value
>   What:		/sys/.../events/in_voltageY_supply_raw_roc_falling_value
>   What:		/sys/.../events/in_voltageY_raw_roc_rising_value
> @@ -679,6 +731,22 @@ What:		/sys/.../events/in_magn_z_thresh_rising_period
>   What:		/sys/.../events/in_magn_z_thresh_falling_period
>   What:		/sys/.../events/in_magn_z_roc_rising_period
>   What:		/sys/.../events/in_magn_z_roc_falling_period
> +What:		/sys/.../events/in_magn_north_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_roc_rising_period
> +What:		/sys/.../events/in_magn_north_roc_falling_period
> +What:		/sys/.../events/in_magn_north_true_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_true_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_true_roc_rising_period
> +What:		/sys/.../events/in_magn_north_true_roc_falling_period
> +What:		/sys/.../events/in_magn_north_tilt_comp_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_tilt_comp_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_tilt_comp_roc_rising_period
> +What:		/sys/.../events/in_magn_north_tilt_comp_roc_falling_period
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_rising_period
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_thresh_falling_period
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_roc_rising_period
> +What:		/sys/.../events/in_magn_north_true_tilt_comp_roc_falling_period
>   What:		/sys/.../events/in_voltageY_supply_thresh_rising_period
>   What:		/sys/.../events/in_voltageY_supply_thresh_falling_period
>   What:		/sys/.../events/in_voltageY_supply_roc_rising_period
> @@ -776,6 +844,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_tilt_comp_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_tilt_comp_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_en
> @@ -840,6 +912,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_tilt_comp_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_magn_north_true_tilt_comp_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
>

