Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaKCC1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:27:23 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48680 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752715AbaKCC1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:27:20 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH RESEND] tty: serial: 8250_mtk: Fix quot calculation
From: eddie huang <eddie.huang@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <heiko@sntech.de>,
        <yingjoe.chen@gmail.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <ibanezchen@gmail.com>,
        <linux-serial@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <jslaby@suse.cz>,
        <alan@linux.intel.com>
In-Reply-To: <9001280.dDNTE2ykLV@wuerfel>
References: <1414773395-9916-1-git-send-email-matthias.brugger@bq.com>
	 <9001280.dDNTE2ykLV@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 3 Nov 2014 10:27:11 +0800
Message-ID: <1414981632.23623.4.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 17:48 +0100, Arnd Bergmann wrote:
> On Friday 31 October 2014 17:36:35 Matthias Brugger wrote:
> > -               quot = DIV_ROUND_CLOSEST(port->uartclk, 256 * baud);
> > +               quot = (port->uartclk / (256 * baud)) + 1;
> 
> Should this be DIV_ROUND_UP then?
> 
> 	Arnd
> 

I think DIV_ROUND_UP is more suitable in this case, and I already do
this and test OK on my MTK platform

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296149.html



