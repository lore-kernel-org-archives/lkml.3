Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3EPKpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:45:55 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35529 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3EPKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:45:51 -0400
Message-ID: <5194B8DA.4080204@gmail.com>
Date: Thu, 16 May 2013 12:45:46 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC] media: OF: add field-active and sync-on-green endpoint
 properties
References: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:52 PM, Lad Prabhakar wrote:
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index e022d2d..6bf87d0 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -101,6 +101,10 @@ Optional endpoint properties
>     array contains only one entry.
>   - clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
>     clock mode.
> +-field-active: a boolean property indicating active high filed ID output
> + polarity is inverted.

You can drop this property and use the existing 'field-even-active' property
instead.

> +-sync-on-green: a boolean property indicating to sync with the green signal in
> + RGB.

> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 83ae07e..b95553d 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -40,6 +40,8 @@
>   #define V4L2_MBUS_FIELD_EVEN_HIGH		(1<<  10)
>   /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
>   #define V4L2_MBUS_FIELD_EVEN_LOW		(1<<  11)
> +#define V4L2_MBUS_FIELD_ACTIVE			(1<<  12)
> +#define V4L2_MBUS_SOG				(1<<  13)

How about V4L2_MBUS_SYNC_ON_GREEN ?

Thanks,
Sylwester
