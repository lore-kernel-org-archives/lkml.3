Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaLALBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:01:17 -0500
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:32942 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbaLALBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:01:14 -0500
Message-ID: <547C4A69.8020002@xs4all.nl>
Date: Mon, 01 Dec 2014 12:00:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: platform: add VPFE capture driver support for
 AM437X
References: <1416791411-9731-1-git-send-email-prabhakar.csengg@gmail.com> <547C3ED3.1060205@xs4all.nl>
In-Reply-To: <547C3ED3.1060205@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 11:11 AM, Hans Verkuil wrote:
> Hi all,
> 
> Thanks for the patch, review comments are below.
> 
> For the next version I would appreciate if someone can test this driver with
> the latest v4l2-compliance from the v4l-utils git repo. If possible test streaming
> as well (v4l2-compliance -s), ideally with both a sensor and a STD receiver input.
> But that depends on the available hardware of course.
> 
> I'd like to see the v4l2-compliance output. It's always good to have that on
> record.
> 
> 
> On 11/24/2014 02:10 AM, Lad, Prabhakar wrote:
>> From: Benoit Parrot <bparrot@ti.com>
>>
>> This patch adds Video Processing Front End (VPFE) driver for
>> AM437X family of devices
>> Driver supports the following:
>> - V4L2 API using MMAP buffer access based on videobuf2 api
>> - Asynchronous sensor/decoder sub device registration
>> - DT support
>>
>> Signed-off-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Darren Etheridge <detheridge@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  .../devicetree/bindings/media/ti-am437xx-vpfe.txt  |   61 +
>>  MAINTAINERS                                        |    9 +
>>  drivers/media/platform/Kconfig                     |    1 +
>>  drivers/media/platform/Makefile                    |    2 +
>>  drivers/media/platform/am437x/Kconfig              |   10 +
>>  drivers/media/platform/am437x/Makefile             |    2 +
>>  drivers/media/platform/am437x/vpfe.c               | 2764 ++++++++++++++++++++
>>  drivers/media/platform/am437x/vpfe.h               |  286 ++
>>  drivers/media/platform/am437x/vpfe_regs.h          |  140 +
>>  include/uapi/linux/Kbuild                          |    1 +
>>  include/uapi/linux/am437x_vpfe.h                   |  122 +
>>  11 files changed, 3398 insertions(+)

Can the source names be improved? There are too many 'vpfe' sources.
Perhaps prefix all with 'am437x-'?

In general I prefer '-' over '_' in a source name: it's looks better
IMHO.

One question, unrelated to this patch series:

Prabhakar, would it make sense to look at the various existing TI sources
as well and rename them to make it more explicit for which SoCs they are
meant? Most are pretty vague with variations on vpe, vpif, vpfe, etc. but
no reference to the actual SoC they are for.

Regards,

	Hans
