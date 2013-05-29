Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967024Ab3E2UqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:46:00 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:32942 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966734Ab3E2Upz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:45:55 -0400
Date: Wed, 29 May 2013 22:48:50 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        g.liakhovetski@gmx.de, ezequiel.garcia@free-electrons.com,
        timo.teras@iki.fi
Subject: Re: [RFC 0/3] saa7115: Implement i2c_board_info.platform_data
Message-ID: <20130529204850.GD2367@dell.arpanet.local>
References: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369860078-10334-1-git-send-email-jonarne@jonarne.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:41:15PM +0200, Jon Arne Jørgensen wrote:
> This patch set adds handling of the i2c_board_info struct to the saa7115 driver.
> The main goal of this patch is to give the different devices with the gm7113c
> chip an opportunity to configure the chip to their needs.
> 
> I've only implemented the overrides I know are necessary to get the stk1160
> and the smi2021 drivers to work.
> 
> The first patch in the series sets the saa7113 init table to the defaults
> according to the datasheet. Maybe it's better to add a new initialization
> table for the gm7113c chip to avoid breaking devices that depend on the
> settings as they are now?
> That would introduce some unneeded code duplication.
>

Hi,
I just realized that there are som grave errors in patch 3 in the
series.

I'll fix them and repost this series.

Best regards,
Jon Arne Jørgensen
 
> Jon Arne Jørgensen (3):
>   saa7115: Set saa7113 init to values from datasheet
>   saa7115: [gm7113c] Remove unneeded register change
>   saa7115: Implement i2c_board_info.platform data
> 
>  drivers/media/i2c/saa7115.c |  91 ++++++++++++++++++++++++------------
>  include/media/saa7115.h     | 109 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 170 insertions(+), 30 deletions(-)
> 
> -- 
> 1.8.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
