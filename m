Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbaGHPLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:11:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46289 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaGHPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:11:36 -0400
Date: Tue, 8 Jul 2014 18:11:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Levente Kurusa <lkurusa@redhat.com>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, prabhakar.csengg@gmail.com,
        Linux Media <linux-media@vger.kernel.org>,
        Archana Kumari <archanakumari959@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] [media] davinci-vpfe: Fix retcode check
Message-ID: <20140708151110.GQ25880@mwanda>
References: <1404828488-7649-1-git-send-email-andrey.krieger.utkin@gmail.com>
 <CAAsK9AFfn45wyQFsOiCAZXZjXfyPLhz3FxyBO5P_q_48s9ce_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAsK9AFfn45wyQFsOiCAZXZjXfyPLhz3FxyBO5P_q_48s9ce_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 04:32:57PM +0200, Levente Kurusa wrote:
> 2014-07-08 16:08 GMT+02:00 Andrey Utkin <andrey.krieger.utkin@gmail.com>:
> > Use signed type to check correctly for negative error code. The issue
> > was reported with static analyser:
> >
> > [linux-3.13/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c:270]:
> > (style) A pointer can not be negative so it is either pointless or an
> > error to check if it is.
> >
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=69071
> > Reported-by: David Binderman <dcb314@hotmail.com>
> > Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> 
> Hmm, while it is true that get_ipipe_mode returns an int, but
> the consequent call to regw_ip takes an u32 as its second
> argument. Did it cause a build warning for you?

It won't cause a compile warning.

> (Can't really
> check since I don't have ARM cross compilers close-by)

Make a small test program and test.

regards,
dan carpenter

