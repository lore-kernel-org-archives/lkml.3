Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaFMIjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:39:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44749 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFMIjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:39:00 -0400
Date: Fri, 13 Jun 2014 11:38:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>, Lidza Louina <lidza.louina@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/9] staging: dgap: introduce dgap_tty_unregister()
Message-ID: <20140613083846.GY5500@mwanda>
References: <20140613074147.GA31615@devel.8.8.4.4>
 <20140613080017.GC5015@mwanda>
 <CAHb8M2D=QCm0Aeci2NsEs71K5Ev-oKGOm7XqTU0=e6qm3Fcf7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2D=QCm0Aeci2NsEs71K5Ev-oKGOm7XqTU0=e6qm3Fcf7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 05:16:27PM +0900, DaeSeok Youn wrote:
> Hi, Dan
> 
> 
> 
> 2014-06-13 17:00 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Fri, Jun 13, 2014 at 04:41:47PM +0900, Daeseok Youn wrote:
> >> dgap_tty_unregister() will unregister serial_driver
> >> and print_driver, and also free related variables.
> >>
> >
> > Introducing a static function without a caller will cause a GCC warning
> > about unused functions.
> >
> > Fold 5,7 and 8 together into one patch.  This is still "one thing per
> > patch" because they can't be done separately.
> OK. I will do. And then this series of patches will resend, right?

I'm afraid so.  New GCC warnings are against the rules even if you fix
it in a later patch.

Since you're redoing it, can I suggest that patch 8 should just move
the code to dgap_init_one() and change the dgap_firmware_load()
prototype and then another patch should add the error handling.

regards,
dan carpenter
