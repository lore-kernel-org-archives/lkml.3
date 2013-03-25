Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680Ab3CYXJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:09:39 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36580 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab3CYXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:09:38 -0400
Message-ID: <5150D92A.4000206@gmail.com>
Date: Tue, 26 Mar 2013 10:09:30 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v3 3/3] backlight: as3711: add OF support
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de> <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de> <20130325154046.82d9337f25cec12b9fa03625@linux-foundation.org>
In-Reply-To: <20130325154046.82d9337f25cec12b9fa03625@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/13 09:40, Andrew Morton wrote:
> On Fri, 22 Mar 2013 17:15:49 +0100 Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
>> Add support for configuring AS3711 backlight driver from DT.
>>
>> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
>> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> ---
>>  drivers/video/backlight/as3711_bl.c |  118 ++++++++++++++++++++++++++++++++++-
>>  1 files changed, 117 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
>> index 41d52fe..123887c 100644
>> --- a/drivers/video/backlight/as3711_bl.c
>> +++ b/drivers/video/backlight/as3711_bl.c
>> @@ -258,6 +258,109 @@ static int as3711_bl_register(struct platform_device *pdev,
>>  	return 0;
>>  }
>>  
>> +static int as3711_backlight_parse_dt(struct device *dev)
>> +{
>> +	struct as3711_bl_pdata *pdata = dev_get_platdata(dev);
>> +	struct device_node *bl =
>> +		of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
>> +	int ret;
> 
> It's tidier to do
> 
> 	struct device_node *bl;
> 	
> 	bl = of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
> 
> and avoid the 80-col trickery.

The other reason being that it now becomes much more apparent that *fb
is not an argument to of_find_node_by_name(), but a second variable of
type struct device_node :-).

~Ryan

