Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab3GDHXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:23:05 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:58499 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3GDHXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:23:03 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, manonuevo@micron.com,
        tqnguyen@micron.com, balbi@ti.com, rnayak@ti.com,
        linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: mtd: spinand: Add generic spinand frameowrk.
Date: Thu, 04 Jul 2013 08:21:59 +0100
Message-ID: <1390226.n8Vjs1lthe@lenovo>
Organization: OpenWrt
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.4; x86_64; ; )
In-Reply-To: <51D4FD7F.3020104@ti.com>
References: <1372851110-580-1-git-send-email-sourav.poddar@ti.com> <CAGVrzcbuK-xBeCVTsXhgEbX9CRqt8Dj7++ikoNZW8bY24Uz2Zg@mail.gmail.com> <51D4FD7F.3020104@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Le jeudi 4 juillet 2013 10:13:43 Sourav Poddar a écrit :
> > 
> > Can this somehow be made a runtime thing?
> 
> Ahh..I think we might opt for a device tree entry and based on that
> check for ECC.

Ok, sounds good too.

> 
> > [snip]
> > 
> >> +               if (count<  oob_num&&  ops->oobbuf&&  chip->oobbuf) {
> >> +                       int size;
> >> +                       int offset, len, temp;
> >> +
> >> +                       /* repack spare to oob */
> >> +                       memset(chip->oobbuf, 0,
> >> info->ecclayout->oobavail);
> >> +
> >> +                       temp = 0;
> >> +                       offset = info->ecclayout->oobfree[0].offset;
> >> +                       len = info->ecclayout->oobfree[0].length;
> >> +                       memcpy(chip->oobbuf + temp,
> >> +                               chip->buf + info->page_main_size +
> >> offset, len);> 
> > Sounds like a for look might be useful here
> 
> I dont think so, there is a while loop above under which it happens.
> We are increasing count at the bottom of the while loop. So, I think
> this should work fine.

What I meant here, is that you could use a for loop to repeat 4 times the same 
following pattern, such that it becomes:

for (j = 0; j < 4; j++0 {
	temp += len;
	offset = info->ecclayout->oobfree[j].offset;
	len = info->ecclayout->oobfree[j].length;
	memcpy(chip->oobbuf + temp,
		chip->buf + info->page_main_size + offset, len);
}

Or even make it a helper function which is inlined if that is deemed more 
elegant.
-- 
Florian
