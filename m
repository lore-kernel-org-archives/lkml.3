Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3GYVMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:12:06 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:17548 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3GYVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:12:01 -0400
Message-ID: <51F1949D.3000706@tilera.com>
Date: Thu, 25 Jul 2013 17:11:57 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 04/36] tile: srom: convert srom_class to use dev_groups
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org> <1374703539-9705-5-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1374703539-9705-5-git-send-email-gregkh@linuxfoundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2013 6:13 PM, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the tile srom_class code to use
> the correct field.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/char/tile-srom.c | 28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)

I just got a failed build email from the kisskb build server:

drivers/char/tile-srom.c:308:2: error: initializer element is not computable at load time
drivers/char/tile-srom.c:308:2: error: (near initialization for 'srom_dev_attrs[0].mode')

plus a bunch of warnings:

drivers/char/tile-srom.c:307:2: warning: missing braces around initializer [-Wmissing-braces]
drivers/char/tile-srom.c:307:2: warning: (near initialization for 'srom_dev_attrs[0]') [-Wmissing-braces]
drivers/char/tile-srom.c:307:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/char/tile-srom.c:307:2: warning: (near initialization for 'srom_dev_attrs[0].name') [enabled by default]
drivers/char/tile-srom.c:308:2: warning: initialization makes integer from pointer without a cast [enabled by default]
drivers/char/tile-srom.c:308:2: warning: (near initialization for 'srom_dev_attrs[0].mode') [enabled by default]
drivers/char/tile-srom.c:309:2: warning: initialization from incompatible pointer type [enabled by default]
drivers/char/tile-srom.c:309:2: warning: (near initialization for 'srom_dev_attrs[1].name') [enabled by default]
drivers/char/tile-srom.c:310:2: warning: initialization makes integer from pointer without a cast [enabled by default]
drivers/char/tile-srom.c:310:2: warning: (near initialization for 'srom_dev_attrs[1].mode') [enabled by default]
drivers/char/tile-srom.c:312:1: warning: initialization from incompatible pointer type [enabled by default]
drivers/char/tile-srom.c:312:1: warning: (near initialization for 'srom_dev_group.attrs') [enabled by default]
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
