Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbaDILFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:05:19 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64863 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaDILFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:05:11 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-33-53452964ef75
Message-id: <53452960.5070501@samsung.com>
Date: Wed, 09 Apr 2014 13:05:04 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.samsung-soc,gmane.linux.kernel,gmane.linux.drivers.devicetree,gmane.linux.drivers.video-input-infrastructure,gmane.comp.video.dri.devel
To: Andrzej Hajda <a.hajda@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, rahul.sharma@samsung.com
Subject: Re: [PATCHv2 2/3] drm: exynos: hdmi: use hdmiphy as PHY
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
 <1396967856-27470-3-git-send-email-t.stanislaws@samsung.com>
 <53452157.9030203@samsung.com>
In-reply-to: <53452157.9030203@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xq7qpmq7BBssrLW6tO8dqMf8IkLjy
	9T2bxYE/OxgtehdcZbO48LSHzeJs0xt2i8u75rBZ9GzYymox4/w+Jospiw6zWrTuPcJuMe/z
	TiYHXo+ds+6ye2xa1cnmcefaHjaP+93HmTz6tqxi9Dh+YzuTx+dNcgHsUVw2Kak5mWWpRfp2
	CVwZrSsnMBVcYq849aGRsYGxga2LkZNDQsBEYuL/HewQtpjEhXvrgeJcHEICSxklHi9sZ4Rw
	PjNKzNqwmRGkildAS+Len0vMXYwcHCwCqhKHllWChNmABh1b8hmsRFQgQmLuxM1sEOWCEj8m
	32MBmcMnsIJRYtm1O+wgjojAMUaJK+cvgq1jFljDKDF7xVKwFmEBB4nNy78yQawGapnZsgts
	LqeAtsT/3uNgRcwCOhL7W6dB2fISm9e8ZZ7AKDgLycpZSMpmISlbwMi8ilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkpr7uYFx6zOoQowAHoxIPr4KlS7AQa2JZcWXuIUYJDmYlEd7nbK7B
	QrwpiZVVqUX58UWlOanFhxiZODilGhgzN/7vbXHxv+O96xZ/wuE7HNv3PZRt3j4zM3tz/YZk
	18scHFquz6ZPPOYtdLDGtqrfeb6jnelS6dhA6V2m81f0fCiRSw0XZLox/dSyZofyyw+2Ob8z
	a/uyYWZYQ8jqzBdPYi6d2uIQ73X8ZtgdpdiY0qAJQvzK7C01wkl/TAsKzY1FWn3YFJRYijMS
	DbWYi4oTAXeIbYmHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,
This issue could be solved by exporting a regmap from PMU driver
or Exynos clock provider for the usage by exynos-simple-phy.
The operations on PHYs from exynos-simple-phy provider would
be chained to PMU driver and protected by a spinlock in the regmap.

Luckily, the divider is not used as far as I know.

Regards,
Tomasz Stanislawski

On 04/09/2014 12:30 PM, Andrzej Hajda wrote:
> Hi Tomasz,
> 
> On 04/08/2014 04:37 PM, Tomasz Stanislawski wrote:
>> The HDMIPHY (physical interface) is controlled by a single
>> bit in a power controller's regiter. It was implemented
>> as clock. It was a simple but effective hack.
> 
> This power controller register has also bits to control HDMI clock
> divider ratio. I guess current drivers do not change it, but how do you
> want to implement access to it if some HDMI driver in the future will
> need to change ratio. I guess in case of clk it would be easier.
> 
> Regards
> Andrzej
> 
> 

