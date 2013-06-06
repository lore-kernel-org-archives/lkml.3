Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab3FFIM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:12:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6138 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599Ab3FFIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:12:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Jun 2013 01:11:49 -0700
Message-ID: <51B0446A.4090305@nvidia.com>
Date: Thu, 6 Jun 2013 17:12:26 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com> <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com>
In-Reply-To: <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>
> On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> Documentation/devicetree/bindings/video/simple-framebuffer.txt | 1 +
>> drivers/video/simplefb.c                                       | 1 +
>> 2 files changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/video/simple-framebuffer.txt b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
>> index 3ea4605..70c26f3 100644
>> --- a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
>> +++ b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
>> @@ -12,6 +12,7 @@ Required properties:
>> - stride: The number of bytes in each line of the framebuffer.
>> - format: The format of the framebuffer surface. Valid values are:
>>    - r5g6b5 (16-bit pixels, d[15:11]=r, d[10:5]=g, d[4:0]=b).
>> +  - a8b8g8r8 (32-bit pixels, d[31:24]=a, d[23:16]=b, d[15:8]=g, d[7:0]=r).
>>
>> Example:
>>
>> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
>> index e2e9e3e..d7041aa 100644
>> --- a/drivers/video/simplefb.c
>> +++ b/drivers/video/simplefb.c
>> @@ -84,6 +84,7 @@ struct simplefb_format {
>>
>> static struct simplefb_format simplefb_formats[] = {
>> 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
>> +	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
>
> why don't you parse the string?
>
> so you will a real generic bindings

Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330

The list of modes of this driver should not grow too big. Even in terms 
of footprint I'd say the list should remain smaller than the parsing code.

What we can discuss though is whether we want to keep this a8b8g8r8 
syntax or switch to something more standard, say "rgba8888".

Alex.

