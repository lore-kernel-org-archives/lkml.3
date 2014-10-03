Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaJCJsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaJCJsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:48:08 -0400
Message-ID: <542E70CF.40205@redhat.com>
Date: Fri, 03 Oct 2014 11:47:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] input: alps: Reset mouse before identifying it
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <1412329392-5580-2-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1412329392-5580-2-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for working on this!

On 10/03/2014 11:43 AM, Pali Rohár wrote:
> On some systems after starting computer function alps_identify() does not detect
> dual ALPS touchpad+trackstick device correctly and detect only touchpad.
> 
> Resetting ALPS device before identifiying it fixing this problem and both parts
> touchpad and trackstick are detected.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Looks good and seems sensible:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

> ---
>  drivers/input/mouse/alps.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> index 35a49bf..1bd5aa1 100644
> --- a/drivers/input/mouse/alps.c
> +++ b/drivers/input/mouse/alps.c
> @@ -2403,6 +2403,8 @@ int alps_detect(struct psmouse *psmouse, bool set_properties)
>  {
>  	struct alps_data dummy;
>  
> +	psmouse_reset(psmouse);
> +
>  	if (alps_identify(psmouse, &dummy) < 0)
>  		return -1;
>  
> 
