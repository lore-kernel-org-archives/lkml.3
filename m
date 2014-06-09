Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaFIRtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:49:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:59598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaFIRtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:49:03 -0400
Message-ID: <5395F3FB.6020204@kernel.org>
Date: Mon, 09 Jun 2014 18:50:51 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        linux-input@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCHv2 1/3] IIO: Documentation: Add north attribute to ABI
 docs
References: <1401750890-31854-1-git-send-email-reyad.attiyat@gmail.com> <1401750890-31854-2-git-send-email-reyad.attiyat@gmail.com>
In-Reply-To: <1401750890-31854-2-git-send-email-reyad.attiyat@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/14 00:14, Reyad Attiyat wrote:
> Updated ABI documentation to inculde compass north usages.
>
> Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
Amazing how many lines of documentation two small additions can make!

Anyhow, I'm keener on having these as as modifiers on a rotation rather than
there own type.

in_rot_from_north_magnetic_raw and friends (as per your suggestion elsewhere).

Otherwise, whilst obvious, perhaps a line or two in the main _raw attribute
description to state the obvious and say what this is...


J

> ---
>   Documentation/ABI/testing/sysfs-bus-iio | 76 +++++++++++++++++++++++++++++++++
>   1 file changed, 76 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index 6e02c50..251c2bb 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -165,6 +165,10 @@ Description:
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_raw
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_raw
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_magnetic_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_true_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_magnetic_tilt_comp_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_true_tilt_comp_raw
>   KernelVersion:	2.6.35
>   Contact:	linux-iio@vger.kernel.org
>   Description:
> @@ -249,6 +253,10 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_magn_z_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_magnetic_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_true_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_magnetic_tilt_comp_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_north_true_tilt_comp_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
>   What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
>   KernelVersion:	2.6.35
> @@ -436,6 +444,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_y_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_tilt_comp_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_tilt_comp_thresh_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_tilt_comp_thresh_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_tilt_comp_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_rising_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_thresh_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_thresh_rising_en
> @@ -481,6 +497,14 @@ What:		/sys/.../iio:deviceX/events/in_magn_y_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_y_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_magn_z_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_tilt_comp_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_magnetic_tilt_comp_roc_falling_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_tilt_comp_roc_rising_en
> +What:		/sys/.../iio:deviceX/events/in_north_true_tilt_comp_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_rising_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_supply_roc_falling_en
>   What:		/sys/.../iio:deviceX/events/in_voltageY_roc_rising_en
> @@ -527,6 +551,14 @@ What:		/sys/.../events/in_magn_y_raw_thresh_rising_value
>   What:		/sys/.../events/in_magn_y_raw_thresh_falling_value
>   What:		/sys/.../events/in_magn_z_raw_thresh_rising_value
>   What:		/sys/.../events/in_magn_z_raw_thresh_falling_value
> +What:		/sys/.../events/in_north_magnetic_raw_thresh_rising_value
> +What:		/sys/.../events/in_north_magnetic_raw_thresh_falling_value
> +What:		/sys/.../events/in_north_true_raw_thresh_rising_value
> +What:		/sys/.../events/in_north_true_raw_thresh_falling_value
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_raw_thresh_rising_value
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_raw_thresh_falling_value
> +What:		/sys/.../events/in_north_true_tilt_comp_raw_thresh_rising_value
> +What:		/sys/.../events/in_north_true_tilt_comp_raw_thresh_falling_value
>   What:		/sys/.../events/in_voltageY_supply_raw_thresh_rising_value
>   What:		/sys/.../events/in_voltageY_supply_raw_thresh_falling_value
>   What:		/sys/.../events/in_voltageY_raw_thresh_rising_value
> @@ -577,6 +609,18 @@ What:		/sys/.../events/in_magn_y_thresh_either_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_rising_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_falling_hysteresis
>   What:		/sys/.../events/in_magn_z_thresh_either_hysteresis
> +What:		/sys/.../events/in_north_magnetic_thresh_rising_hysteresis
> +What:		/sys/.../events/in_north_magnetic_thresh_falling_hysteresis
> +What:		/sys/.../events/in_north_magnetic_thresh_either_hysteresis
> +What:		/sys/.../events/in_north_true_thresh_rising_hysteresis
> +What:		/sys/.../events/in_north_true_thresh_falling_hysteresis
> +What:		/sys/.../events/in_north_true_thresh_either_hysteresis
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_thresh_rising_hysteresis
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_thresh_falling_hysteresis
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_thresh_either_hysteresis
> +What:		/sys/.../events/in_north_true_tilt_comp_thresh_rising_hysteresis
> +What:		/sys/.../events/in_north_true_tilt_comp_thresh_falling_hysteresis
> +What:		/sys/.../events/in_north_true_tilt_comp_thresh_either_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_rising_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_falling_hysteresis
>   What:		/sys/.../events/in_voltageY_thresh_either_hysteresis
> @@ -624,6 +668,14 @@ What:		/sys/.../events/in_magn_y_raw_roc_rising_value
>   What:		/sys/.../events/in_magn_y_raw_roc_falling_value
>   What:		/sys/.../events/in_magn_z_raw_roc_rising_value
>   What:		/sys/.../events/in_magn_z_raw_roc_falling_value
> +What:		/sys/.../events/in_north_magnetic_raw_roc_rising_value
> +What:		/sys/.../events/in_north_magnetic_raw_roc_falling_value
> +What:		/sys/.../events/in_north_true_raw_roc_rising_value
> +What:		/sys/.../events/in_north_true_raw_roc_falling_value
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_raw_roc_rising_value
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_raw_roc_falling_value
> +What:		/sys/.../events/in_north_true_tilt_comp_raw_roc_rising_value
> +What:		/sys/.../events/in_north_true_tilt_comp_raw_roc_falling_value
>   What:		/sys/.../events/in_voltageY_supply_raw_roc_rising_value
>   What:		/sys/.../events/in_voltageY_supply_raw_roc_falling_value
>   What:		/sys/.../events/in_voltageY_raw_roc_rising_value
> @@ -679,6 +731,22 @@ What:		/sys/.../events/in_magn_z_thresh_rising_period
>   What:		/sys/.../events/in_magn_z_thresh_falling_period
>   What:		/sys/.../events/in_magn_z_roc_rising_period
>   What:		/sys/.../events/in_magn_z_roc_falling_period
> +What:		/sys/.../events/in_north_magnetic_thresh_rising_period
> +What:		/sys/.../events/in_north_magnetic_thresh_falling_period
> +What:		/sys/.../events/in_north_magnetic_roc_rising_period
> +What:		/sys/.../events/in_north_magnetic_roc_falling_period
> +What:		/sys/.../events/in_north_true_thresh_rising_period
> +What:		/sys/.../events/in_north_true_thresh_falling_period
> +What:		/sys/.../events/in_north_true_roc_rising_period
> +What:		/sys/.../events/in_north_true_roc_falling_period
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_thresh_rising_period
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_thresh_falling_period
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_roc_rising_period
> +What:		/sys/.../events/in_north_magnetic_tilt_comp_roc_falling_period
> +What:		/sys/.../events/in_north_true_tilt_comp_thresh_rising_period
> +What:		/sys/.../events/in_north_true_tilt_comp_thresh_falling_period
> +What:		/sys/.../events/in_north_true_tilt_comp_roc_rising_period
> +What:		/sys/.../events/in_north_true_tilt_comp_roc_falling_period
>   What:		/sys/.../events/in_voltageY_supply_thresh_rising_period
>   What:		/sys/.../events/in_voltageY_supply_thresh_falling_period
>   What:		/sys/.../events/in_voltageY_supply_roc_rising_period
> @@ -776,6 +844,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_magnetic_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_true_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_magnetic_tilt_comp_en
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_true_tilt_comp_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_supply_en
>   What:		/sys/.../iio:deviceX/scan_elements/in_voltageY_en
> @@ -840,6 +912,10 @@ What:		/sys/.../iio:deviceX/scan_elements/in_anglvel_z_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_x_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_magn_z_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_magnetic_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_true_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_magnetic_tilt_comp_index
> +What:		/sys/.../iio:deviceX/scan_elements/in_north_true_tilt_comp_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_x_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_incli_y_index
>   What:		/sys/.../iio:deviceX/scan_elements/in_timestamp_index
>

