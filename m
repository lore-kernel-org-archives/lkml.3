Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256Ab3EBNCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:02:30 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62895 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab3EBNC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:02:29 -0400
Message-ID: <518263F7.70204@suse.cz>
Date: Thu, 02 May 2013 15:02:47 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net, chf.fritz@googlemail.com, mkl@pengutronix.de
Subject: [stable 3.0] ppc build breakage [was: Linux 3.0.75]
References: <20130426043017.GA22553@kroah.com>
In-Reply-To: <20130426043017.GA22553@kroah.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 06:30 AM, Greg KH wrote:
> Christoph Fritz (1): can: sja1000: fix handling on dt properties on
> little endian systems

Hi, this one breaks ppc builds:
drivers/net/can/sja1000/sja1000_of_platform.c: In function
'sja1000_ofp_probe':
drivers/net/can/sja1000/sja1000_of_platform.c:138: error: implicit
declaration of function 'of_property_read_u32'
drivers/net/can/sja1000/sja1000_of_platform.c:168: error: implicit
declaration of function 'of_property_read_bool'


They depend on:
commit a3b853633d78c3930b513ee219df48637ac82eed
Author: Thomas Abraham <thomas.abraham@linaro.org>
Date:   Thu Jun 30 21:26:10 2011 +0530

    dt: add helper functions to read u32 and string property values
==== and ====
commit fa4d34ccd0914ac87336ea2c17e9370dfecef286
Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date:   Tue Feb 7 12:12:51 2012 +0800

    of: introduce helper to manage boolean


but neither of those is in 3.0...

thanks,
-- 
js
suse labs
