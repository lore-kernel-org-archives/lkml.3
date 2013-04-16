Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3DPJOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3DPJOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:14:51 -0400
Date: Tue, 16 Apr 2013 06:12:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Antti Palosaari <crope@iki.fi>, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH -next] media:
Message-ID: <20130416061243.22d06140@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1304152010180.3952@chino.kir.corp.google.com>
References: <20130408174343.cc13eb1972470d20d38ecff1@canb.auug.org.au>
	<51630297.2040803@infradead.org>
	<516461FE.4020007@iki.fi>
	<alpine.DEB.2.02.1304152010180.3952@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 15 Apr 2013 20:10:49 -0700 (PDT)
David Rientjes <rientjes@google.com> escreveu:

> On Tue, 9 Apr 2013, Antti Palosaari wrote:
> 
> > On 04/08/2013 08:47 PM, Randy Dunlap wrote:
> > > From: Randy Dunlap <rdunlap@infradead.org>
> > > 
> > > Fix randconfig error when USB is not enabled:
> > > 
> > > ERROR: "usb_control_msg" [drivers/media/common/cypress_firmware.ko]
> > > undefined!
> > > 
> > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > Cc: Antti Palosaari <crope@iki.fi>
> > 
> > Reviewed-by: Antti Palosaari <crope@iki.fi>
> > 
> > 
> > > ---
> > >   drivers/media/common/Kconfig |    1 +
> > >   1 file changed, 1 insertion(+)
> > > 
> > > --- linux-next-20130408.orig/drivers/media/common/Kconfig
> > > +++ linux-next-20130408/drivers/media/common/Kconfig
> > > @@ -18,6 +18,7 @@ config VIDEO_TVEEPROM
> > > 
> > >   config CYPRESS_FIRMWARE
> > >   	tristate "Cypress firmware helper routines"
> > > +	depends on USB
> > > 
> > >   source "drivers/media/common/b2c2/Kconfig"
> > >   source "drivers/media/common/saa7146/Kconfig"
> > > 
> 
> Mauro, this problem persists in linux-next seven days later, any chance we 
> can get this fix from Randy merged?

AFAIKT, this got merged at -next already:

commit 7c15b715ef301a7f8bb2dc8de335497ffde568a6
Author:     Randy Dunlap <rdunlap@infradead.org>
AuthorDate: Mon Apr 8 13:47:03 2013 -0300
Commit:     Mauro Carvalho Chehab <mchehab@redhat.com>
CommitDate: Sun Apr 14 20:04:08 2013 -0300

    [media] media: Fix randconfig error
    
    Fix randconfig error when USB is not enabled:
    ERROR: "usb_control_msg" [drivers/media/common/cypress_firmware.ko] undefined!
    
    Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
    Reviewed-by: Antti Palosaari <crope@iki.fi>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Regards,
Mauro
