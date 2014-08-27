Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaH0IZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:25:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaH0IZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:25:51 -0400
Date: Wed, 27 Aug 2014 10:25:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: picolcd: sanity check report size in raw_event()
 callback
In-Reply-To: <20140827101311.098f3fd1@pluto>
Message-ID: <alpine.LNX.2.00.1408271025040.2992@pobox.suse.cz>
References: <alpine.LNX.2.00.1408270911130.2992@pobox.suse.cz> <alpine.LNX.2.00.1408270912310.2992@pobox.suse.cz> <20140827101311.098f3fd1@pluto>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Bruno Prémont wrote:

> > The report passed to us from transport driver could potentially be 
> > arbitrarily large, therefore we better sanity-check it so that raw_data 
> > that we hold in picolcd_pending structure are always kept within proper 
> > bounds.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Steven Vittitoe <scvitti@google.com>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Acked-by: Bruno Prémont <bonbons@linux-vserver.org>

Thanks.

> > ---
> >  drivers/hid/hid-picolcd_core.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
> > index acbb0210..020df3c 100644
> > --- a/drivers/hid/hid-picolcd_core.c
> > +++ b/drivers/hid/hid-picolcd_core.c
> > @@ -350,6 +350,12 @@ static int picolcd_raw_event(struct hid_device *hdev,
> >  	if (!data)
> >  		return 1;
> >  
> > +	if (size > 64) {
> > +		hid_warn(hdev, "invalid size value (%d) for picolcd raw event\n",
> > +				size);
> 
> Is it worth adding report->id to this hid_warn()?
> 
> A valid device is not expected to ever send >64 bytes reports but in
> case a firmware update would do so it would help to know for which
> report it was.

It definitely wouldn't hurt. Pull request with the original patch is now 
on its way to Linus though, so let's do this as a followup patch on top 
once this is merged.

-- 
Jiri Kosina
SUSE Labs
