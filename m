Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaGGUw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:52:28 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:46742 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaGGUw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdV++wyFLbqmnqEBTrWdgTNKpy=r9-mYFhQGCj7kUUUhKQ@mail.gmail.com>
References: <1404667555-14675-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<CAMuHMdV++wyFLbqmnqEBTrWdgTNKpy=r9-mYFhQGCj7kUUUhKQ@mail.gmail.com>
Date: Mon, 7 Jul 2014 22:52:26 +0200
Message-ID: <CAFo99gaWUTzbxgmA6ahtFhCOBog1iYBx1oSvr9m_rAQgcNq6oA@mail.gmail.com>
Subject: Re: [PATCH] video: fbdev: core: fbmon.c: Cleaning up useless
 assignment of function parameter
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, David Ung <davidu@nvidia.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-07 22:43 GMT+02:00 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Sun, Jul 6, 2014 at 7:25 PM, Rickard Strandqvist
> <rickard_strandqvist@spectrumdigital.se> wrote:
>> Remove assignment of function parameter, that has no effect outside the function
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/video/fbdev/core/fbmon.c |    1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/video/fbdev/core/fbmon.c b/drivers/video/fbdev/core/fbmon.c
>> index 5b0e313..71ec1ab 100644
>> --- a/drivers/video/fbdev/core/fbmon.c
>> +++ b/drivers/video/fbdev/core/fbmon.c
>> @@ -1481,7 +1481,6 @@ int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>>  }
>>  void fb_edid_to_monspecs(unsigned char *edid, struct fb_monspecs *specs)
>>  {
>> -       specs = NULL;
>
> I guess the intention was:
>
> memset(specs, 0, sizeof(struct fb_monspecs));


Hi Geert!

Yeah, maybe. Just looks to be a little too elementary mistake..?

But do you want me to change it to that?

With a:
if(specs)
  memset()

maybe..?


Kind regards
Rickard Strandqvist
