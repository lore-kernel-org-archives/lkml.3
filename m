Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaGIFaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:30:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbaGIFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:30:07 -0400
Date: Tue, 8 Jul 2014 22:29:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, Fabio Falzoi <fabio.falzoi84@gmail.com>,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v3 2/4] Staging: rts5208: Replace custom macro with
 print_hex_dump_bytes
Message-ID: <20140709052950.GA8051@kroah.com>
References: <1404855512-5864-1-git-send-email-fabio.falzoi84@gmail.com>
 <1404855512-5864-3-git-send-email-fabio.falzoi84@gmail.com>
 <20140708234529.GA25645@kroah.com>
 <1404870498.932.79.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404870498.932.79.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:48:18PM -0700, Joe Perches wrote:
> On Tue, 2014-07-08 at 16:45 -0700, Greg KH wrote:
> > On Tue, Jul 08, 2014 at 11:38:30PM +0200, Fabio Falzoi wrote:
> > > Use print_hex_dump_bytes to have memory properly dumped only when
> > > DEBUG is defined.
> []
> > > diff --git a/drivers/staging/rts5208/trace.h b/drivers/staging/rts5208/trace.h
> []
> > > @@ -82,12 +82,11 @@ static inline char *filename(char *path)
> []
> > > +static inline void rtsx_hex_dump(const void *buf, size_t len)
> > > +{
> > > +#ifdef DEBUG
> > > +	print_hex_dump_bytes(KBUILD_MODNAME ": ", DUMP_PREFIX_NONE, buf, len);
> > >  #endif
> > > +}
> > 
> > What a mess.  What's wrong with just using the %*ph modifier in
> > dev_dbg() like other drivers do?
> 
> Dunno.
> Is it ever desired to emit more than 64 bytes of buf?

I doubt it really matters :)
