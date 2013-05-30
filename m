Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3E3FSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:18:55 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:34100 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751182Ab3E3FSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:18:48 -0400
Date: Thu, 30 May 2013 07:21:36 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Subject: Re: [RFC 1/3] saa7115: Set saa7113 init to values from datasheet
Message-ID: <20130530052136.GF2367@dell.arpanet.local>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
 <1369860078-10334-2-git-send-email-jonarne@jonarne.no>
 <20130529213554.690f7eaa@redhat.com>
 <7454763a-75fe-4d98-b7ab-29b6649dc25e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7454763a-75fe-4d98-b7ab-29b6649dc25e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:19:49PM -0400, Andy Walls wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> >Em Wed, 29 May 2013 22:41:16 +0200
> >Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> >
> >> Change all default values in the initial setup table to match the
> >table
> >> in the datasheet.
> >
> >This is not a good idea, as it can produce undesired side effects
> >on the existing drivers that depend on it, and can't be easily
> >tested.
> >
> >Please, don't change the current "default". It is, of course, OK
> >to change them if needed via the information provided inside the
> >platform data.
> >
> >Regards,
> >Mauro
> >> 
> >> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> >> ---
> >>  drivers/media/i2c/saa7115.c | 12 ++++++------
> >>  1 file changed, 6 insertions(+), 6 deletions(-)
> >> 
> >> diff --git a/drivers/media/i2c/saa7115.c
> >b/drivers/media/i2c/saa7115.c
> >> index d6f589a..4403679 100644
> >> --- a/drivers/media/i2c/saa7115.c
> >> +++ b/drivers/media/i2c/saa7115.c
> >> @@ -223,12 +223,12 @@ static const unsigned char saa7111_init[] = {
> >>  static const unsigned char saa7113_init[] = {
> >>  	R_01_INC_DELAY, 0x08,
> >>  	R_02_INPUT_CNTL_1, 0xc2,
> >> -	R_03_INPUT_CNTL_2, 0x30,
> >> +	R_03_INPUT_CNTL_2, 0x33,
> >>  	R_04_INPUT_CNTL_3, 0x00,
> >>  	R_05_INPUT_CNTL_4, 0x00,
> >> -	R_06_H_SYNC_START, 0x89,
> >> +	R_06_H_SYNC_START, 0xe9,
> >>  	R_07_H_SYNC_STOP, 0x0d,
> >> -	R_08_SYNC_CNTL, 0x88,
> >> +	R_08_SYNC_CNTL, 0x98,
> >>  	R_09_LUMA_CNTL, 0x01,
> >>  	R_0A_LUMA_BRIGHT_CNTL, 0x80,
> >>  	R_0B_LUMA_CONTRAST_CNTL, 0x47,
> >> @@ -236,11 +236,11 @@ static const unsigned char saa7113_init[] = {
> >>  	R_0D_CHROMA_HUE_CNTL, 0x00,
> >>  	R_0E_CHROMA_CNTL_1, 0x01,
> >>  	R_0F_CHROMA_GAIN_CNTL, 0x2a,
> >> -	R_10_CHROMA_CNTL_2, 0x08,
> >> +	R_10_CHROMA_CNTL_2, 0x00,
> >>  	R_11_MODE_DELAY_CNTL, 0x0c,
> >> -	R_12_RT_SIGNAL_CNTL, 0x07,
> >> +	R_12_RT_SIGNAL_CNTL, 0x01,
> >>  	R_13_RT_X_PORT_OUT_CNTL, 0x00,
> >> -	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
> >> +	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,	/* RESERVED */
> >>  	R_15_VGATE_START_FID_CHG, 0x00,
> >>  	R_16_VGATE_STOP, 0x00,
> >>  	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
> >
> >
> >-- 
> >
> >Cheers,
> >Mauro
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media"
> >in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I was going to make a comment along the same line as Mauro.  
> Please leave the driver defaults alone.  It is almost impossible to regression test all the different devices with a SAA7113 chip, to ensure the change doesn't cause someone's device to not work properly.
>

You guys are totally right.

What if I clone the original saa7113_init table into a new one, and make
the driver use the new one if the calling driver sets platform_data.

Something like this?

        switch (state->ident) {
        case V4L2_IDENT_SAA7111:
        case V4L2_IDENT_SAA7111A:
                saa711x_writeregs(sd, saa7111_init);
                break;
        case V4L2_IDENT_GM7113C:
        case V4L2_IDENT_SAA7113:
-		saa711x_writeregs(sd, saa7113_init);
+		if (client->dev.platform_data)
+			saa711x_writeregs(sd, saa7113_new_init);
+		else
+			saa711x_writeregs(sd, saa7113_init);

                break;
        default:
                state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
                saa711x_writeregs(sd, saa7115_init_auto_input);
        }
        if (state->ident > V4L2_IDENT_SAA7111A)
                saa711x_writeregs(sd, saa7115_init_misc);

        if (client->dev.platform_data) {
                struct saa7115_platform_data *data = client->dev.platform_data;
                saa7115_load_platform_data(state, data);
        }

It's not strictly necessary, but it feels a lot cleaner?
Would you accept this into the kernel, or would it just increase
maintenance?

Best regards
Jon Arne Jørgensen

> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
