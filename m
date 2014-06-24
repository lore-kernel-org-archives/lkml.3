Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaFXLdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:33:38 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:48550 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaFXLde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:33:34 -0400
Message-ID: <1403609569.10831.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 00/22] Add and use pci_zalloc_consistent
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Joe Perches <joe@perches.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-arch@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
        iss_storagedev@hp.com, linux-rdma@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-atm-general@lists.sourceforge.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, linux-crypto@vger.kernel.org,
        linux-eata@i-connect.net, linux-media@vger.kernel.org
Date: Tue, 24 Jun 2014 13:32:49 +0200
In-Reply-To: <CAGRGNgVD2f0S-v8YZ-qABEhDJAwk5pp71FU9uLR8aSZ+DhABjg@mail.gmail.com> (sfid-20140624_012812_032630_4B31BBC9)
References: <cover.1403530604.git.joe@perches.com>
	 <20140623172512.GA1390@garbanzo.do-not-panic.com>
	 <1403550809.15811.13.camel@joe-AO725>
	 <CAGRGNgVD2f0S-v8YZ-qABEhDJAwk5pp71FU9uLR8aSZ+DhABjg@mail.gmail.com>
	 (sfid-20140624_012812_032630_4B31BBC9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 09:27 +1000, Julian Calaby wrote:

> > - x = (T)pci_alloc_consistent(E1,E2,E3);
> > + x = pci_zalloc_consistent(E1,E2,E3);
> >   if ((x==NULL) || ...) S
> > - memset((T2)x,0,E2);
> 
> I don't know much about SmPL, but wouldn't having that if statement
> there reduce your matches?

Code that matched without the if statement would be buggy, since it
wouldn't be checking the pci_zalloc_consistent return value properly.l

johannes

