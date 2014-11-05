Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaKEPfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:35:21 -0500
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40961 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754949AbaKEPfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:35:18 -0500
Message-ID: <545A43A1.1040200@xs4all.nl>
Date: Wed, 05 Nov 2014 16:34:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Hans Verkuil <hansverk@cisco.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-api@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 11/15] [media] Deprecate v4l2_mbus_pixelcode
References: <1415094910-15899-1-git-send-email-boris.brezillon@free-electrons.com>	<1415094910-15899-12-git-send-email-boris.brezillon@free-electrons.com>	<20141105150814.GT3136@valkosipuli.retiisi.org.uk>	<20141105161538.7a1686d5@bbrezillon>	<545A401C.8070908@cisco.com> <20141105163049.65d02aff@bbrezillon>
In-Reply-To: <20141105163049.65d02aff@bbrezillon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/14 16:30, Boris Brezillon wrote:
> On Wed, 05 Nov 2014 16:19:56 +0100
> Hans Verkuil <hansverk@cisco.com> wrote:
> 
>>
>>
>> On 11/05/14 16:15, Boris Brezillon wrote:
>>> On Wed, 5 Nov 2014 17:08:15 +0200
>>> Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>>
>>>> Hi Boris,
>>>>
>>>> On Tue, Nov 04, 2014 at 10:55:06AM +0100, Boris Brezillon wrote:
>>>>> The v4l2_mbus_pixelcode enum (or its values) should be replaced by the
>>>>> media_bus_format enum.
>>>>> Keep this enum in v4l2-mediabus.h and create a new header containing
>>>>> the v4l2_mbus_framefmt struct definition (which is not deprecated) so
>>>>> that we can add a #warning statement in v4l2-mediabus.h and hopefully
>>>>> encourage users to move to the new definitions.
>>>>>
>>>>> Replace inclusion of v4l2-mediabus.h with v4l2-mbus.h in all common headers
>>>>> and update the documentation Makefile to parse v4l2-mbus.h instead of
>>>>> v4l2-mediabus.h.
>>>>>
>>>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>>>> ---
>>>>>  Documentation/DocBook/media/Makefile |  2 +-
>>>>>  include/media/v4l2-mediabus.h        |  2 +-
>>>>>  include/uapi/linux/Kbuild            |  1 +
>>>>>  include/uapi/linux/v4l2-mbus.h       | 35 +++++++++++++++++++++++++++++++++++
>>>>>  include/uapi/linux/v4l2-mediabus.h   | 26 ++++----------------------
>>>>
>>>> I would keep the original file name, even if the compatibility definitions
>>>> are there. I don't see any harm in having them around as well.
>>>>
>>>
>>> That's the part I was not sure about.
>>> The goal of this patch (and the following ones) is to deprecate
>>> v4l2_mbus_pixelcode enum and its values by adding a #warning when
>>> v4l2-mediabus.h file is included, thus encouraging people to use new
>>> definitions.
>>
>> Since v4l2-mediabus.h contains struct v4l2_mbus_framefmt this header remains
>> a legal header, so you can't use #warning here in any case.
>>
> 
> Actually this patch moves the struct v4l2_mbus_framefmt definition into
> another header before adding the warning statement.

There is nothing wrong with keeping the struct in the header. Just keep it
there.

	Hans

> 
> Anyway, this is really a detail, and if everybody agrees that we should
> just leave the old definition in place, I'm fine with that.

