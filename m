Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbaKTUf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:35:28 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40655 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783AbaKTUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:35:26 -0500
Date: Thu, 20 Nov 2014 12:35:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: scott <scott.liu@emc.com.tw>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Vincent Wang <vincent.wang@emc.com.tw>,
        Jeff Chuang <jeff.chuang@emc.com.tw>,
        Benson Leung <bleung@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v1] Input: elants_i2c: Add Elan touchscreen support
Message-ID: <20141120203523.GC14798@dtor-glaptop>
References: <1388146515-19481-1-git-send-email-scott.liu@emc.com.tw>
 <20141120081113.GA37534@dtor-ws>
 <1416479490.28599.13.camel@linux-0dmf.site>
 <20141120174709.GA14798@dtor-glaptop>
 <1416515255.25223.1.camel@linux-0dmf.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416515255.25223.1.camel@linux-0dmf.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 09:27:35PM +0100, Oliver Neukum wrote:
> On Thu, 2014-11-20 at 09:47 -0800, Dmitry Torokhov wrote:
> > Hi Oliver,
> > 
> > On Thu, Nov 20, 2014 at 11:31:30AM +0100, Oliver Neukum wrote:
> > > > +static int elants_i2c_initialize(struct elants_data *ts)
> > > > +{
> > > > +       struct i2c_client *client = ts->client;
> > > > +       int error, retry_cnt;
> > > > +       const u8 hello_packet[] = { 0x55, 0x55, 0x55, 0x55 };
> > > > +       const u8 recov_packet[] = { 0x55, 0x55, 0x80, 0x80 };
> > > > +       u8 buf[HEADER_SIZE];
> > > > +
> > > 
> > > Strictly speaking you should disable preemption here.
> > 
> > Umm, why?
> 
> You said the upper bound matters. So you need to protect yourself
> against losing too much time by preemption.

We are using i2c so we can't really disable preemption here... I think
we  have enough slack, although I would indeed lower the sleep time.
I'll let Scott comment on that.

Thanks.

-- 
Dmitry
