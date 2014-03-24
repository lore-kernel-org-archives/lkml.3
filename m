Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbaCXBFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 21:05:42 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37667 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750749AbaCXBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 21:05:40 -0400
Date: Mon, 24 Mar 2014 03:05:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH/RFC 8/8] DT: Add documentation for exynos4-is
 camera-flash property
Message-ID: <20140324010534.GA2847@valkosipuli.retiisi.org.uk>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-9-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395327070-20215-9-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Mar 20, 2014 at 03:51:10PM +0100, Jacek Anaszewski wrote:
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> index 922d6f8..88f9287 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> @@ -108,6 +108,8 @@ Image sensor nodes
>  The sensor device nodes should be added to their control bus controller (e.g.
>  I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
>  using the common video interfaces bindings, defined in video-interfaces.txt.
> +If the sensor device has a led flash device associated with it then its phandle
> +should be assigned to the camera-flash property.
>  
>  Example:
>  
> @@ -125,6 +127,7 @@ Example:
>  			clock-frequency = <24000000>;
>  			clocks = <&camera 1>;
>  			clock-names = "mclk";
> +			camera-flash = <&led_flash>;
>  
>  			port {
>  				s5k6aa_ep: endpoint {

It's indeed an interesting idea to declare the flash controller in the
sensor's properties rather than those of the ISP. The obvious upside is that
this way it's easy to figure out which subdev group the flash controller
belongs to.

There are a few other things to consider as well:

- You can't have a flash without a sensor. I can't think of why this would
  be a real issue, though.

- Relations other than one-to-one become difficult. One flash but two
  cameras --- think of stereo cameras.

	- One camera and two flashes. I haven't seen any but I don't think
	  that's unthinkable.

- It's not very nice of the ISP driver to just go and parse the
  sensor's properties.

- As the property is FIMC specific, the sensor DT node now carries FIMC
  related information.

A generic solution would be preferrable as this is not a FIMC related
problem.

I have to admit that I can't think of a better solution right now than just
putting a list of the flash device phandles to the ISP device's DT node, and
then adding information on which sensor (numeric ID) the flash is related to
as an array. Better ideas would be welcome.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
