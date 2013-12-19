Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3LSJ7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:59:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3LSJ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:59:07 -0500
Date: Thu, 19 Dec 2013 10:59:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Herrmann <dh.herrmann@gmail.com>
cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, thomas@m3y3r.de,
        list@osuosl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<devel@linuxdriverproject.org>
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to
 memdup
In-Reply-To: <CANq1E4QriATWbfruwj7oVnEBHvtLe_s2yhSSU5COXFjomt5R_A@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1312191058100.28730@pobox.suse.cz>
References: <5237430B.5040009@canonical.com> <20130916203824.GP25896@mwanda> <52376ED9.5080208@canonical.com> <20130916210503.GQ25896@mwanda> <5237A5D5.8010006@canonical.com> <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz> <52432152.3030100@canonical.com>
 <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz> <52459942.3020600@canonical.com> <alpine.LNX.2.00.1312161401100.12882@pobox.suse.cz> <CANq1E4QriATWbfruwj7oVnEBHvtLe_s2yhSSU5COXFjomt5R_A@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013, David Herrmann wrote:

> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 253fe23..81eacd3 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1334,7 +1334,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
> >                 csize--;
> >         }
> >
> > -       rsize = ((report->size - 1) >> 3) + 1;
> > +       rsize = ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
> 
> Isn't "report->id" already covered by "if (report_enum->numbered)"
> above? The test for "id > 0" won't work here as in this case
> "report_enum->numbered" must already be set to true by the hid-desc
> parser, doesn't it?

Right, that one is not correct here, thanks.

> Where exactly did you get the +7 from?

Please see commit (the one I am not really proud of) 27ce405039bfe6d3.

-- 
Jiri Kosina
SUSE Labs
