Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbaEPRnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:43:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:21802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758018AbaEPRnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1068,1389772800"; 
   d="scan'208";a="541711784"
Message-ID: <53764EDE.8090008@linux.intel.com>
Date: Fri, 16 May 2014 10:46:06 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Reyad Attiyat <reyad.attiyat@gmail.com>
CC: jic23@kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: HID Sensor support for True/Magnetic North usage attributes
References: <CA+BWVUShz2_Xd8EBWE+igjYk6Bc+K=LbjCr6EH7hNhvVodka6A@mail.gmail.com>
In-Reply-To: <CA+BWVUShz2_Xd8EBWE+igjYk6Bc+K=LbjCr6EH7hNhvVodka6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 07:14 PM, Reyad Attiyat wrote:
> Dear IIO/HID maintainers,
>
> I have a device, Surface Pro, that has the hid-sensor-hub and many
> sensors attached. With the help of Srinivas I was able to get them all
> working except for the magnometer. It uses the hid-magn-3d driver as
> it should but it does not contain an axis (X, Y, Z) usage attributes.
> Instead it only has a True North usage attribute. I see two solutions
> to this problem and was inquiring which one would work best?
>
> 1) Modify the hid-magn-3d driver to handle True North attribute. I
> realize there might not be many devices that have this so not sure if
> appropriate. I think this could be done; by passing a variable amount
> of IIO Channels when setting up the hid-magn-3d driver, depending on
> how many axis and/or if it find True/Magnetic North usage attribute.
I prefer this approach. The spec doesn't say whether magnetic flux for 
x,y or z are mandatory.
Ultimately they are used to calculate the true north. So if the hub is 
trying to expose true north,
we should add this attribute.

"Heading True North SV – Indicates compass true north heading is not 
compensated.
                     Default unit of measure is degrees; can be 
overridden using
                    explicit Unit and/or Unit Exponent."

Thanks,
Srinivas
> 2) Create a whole new driver that handles True/Magnetic North. This
> would not work on my device as it is set to Compass 3D Usage
> Attribute. This could be resolved by adding another quirk for the
> Surface to ensure it used the new driver.
>
> For both options I think we'd need a new IIO_MOD_NORTH for the
> iio_chan_spec, as the current ones don't really apply. I like the
> first solution as it could allow for handling of devices with only one
> or two axis present. I do realize if the hid-mangn-3d driver was
> changed it's name would not make sense anymore and the pattern I'm
> notcing is a driver for each HID Usage.
>
> Here's a link to the hid report description with some labels for my device:
> Bug 73321 Comment 7
> https://bugzilla.kernel.org/show_bug.cgi?id=73321#c7
>
> I'd be willing to work on this. Just wanted to know what would work best
>
> Thank You,
> Reyad Attiyat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

