Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbbAMNqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:46:45 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36793 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbbAMNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:46:42 -0500
MIME-Version: 1.0
In-Reply-To: <20150113133903.GV4891@lukather>
References: <1420705079-3741-1-git-send-email-prabhakar.csengg@gmail.com>
 <1420705079-3741-3-git-send-email-prabhakar.csengg@gmail.com>
 <54B504EF.4000809@ti.com> <CA+V-a8u0RARw84FYa661VZCYpXkZYkXmtc03jCXU=t0aoGvg9Q@mail.gmail.com>
 <20150113133903.GV4891@lukather>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 13 Jan 2015 13:46:10 +0000
Message-ID: <CA+V-a8ub8spDFvAU8Rfga00oekxAmMtoxSbG0fsoTHsZ7n6TSQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] fbdev: ssd1307fb: check return value while setting offset
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 1:39 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Tue, Jan 13, 2015 at 11:53:01AM +0000, Prabhakar Lad wrote:
>> On Tue, Jan 13, 2015 at 11:43 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
>> > On 08/01/15 10:17, Lad, Prabhakar wrote:
>> >> this patch checks the return value of write command while
>> >> setting the display offset.
>> >>
>> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >> ---
>> >>  drivers/video/fbdev/ssd1307fb.c | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
>> >> index 70e3ce8..a7ecaa6 100644
>> >> --- a/drivers/video/fbdev/ssd1307fb.c
>> >> +++ b/drivers/video/fbdev/ssd1307fb.c
>> >> @@ -342,7 +342,7 @@ static int ssd1307fb_ssd1306_init(struct ssd1307fb_par *par)
>> >>
>> >>       /* set display offset value */
>> >>       ret = ssd1307fb_write_cmd(par->client, SSD1307FB_SET_DISPLAY_OFFSET);
>> >> -     ret = ssd1307fb_write_cmd(par->client, 0x20);
>> >> +     ret = ret & ssd1307fb_write_cmd(par->client, 0x20);
>> >>       if (ret < 0)
>> >>               return ret;
>> >
>> > Hrm, what's that supposed to do? If both calls to ssd1307fb_write_cmd()
>> > return an error, they are anded, resulting in a garbage error code...
>> >
>> Agreed I have just aligned this to rest of the code in this function.
>>
>> Maxime if you are OK I'll post a patch returning error then and there ?
>
> I'm not sure what the question is, but Tomi is right, having two
> returns seems the right thing to do.
>
OK I'll post a new patch having two separate returns.

Thanks,
--Prabhakar Lad
