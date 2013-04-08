Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936146Ab3DHUpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:45:17 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:50093 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935724Ab3DHUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:45:15 -0400
Date: Mon, 8 Apr 2013 22:45:10 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/drbd: remove erroneous semicolon
Message-ID: <20130408204510.GB13761@soda.linbit>
Mail-Followup-To: Chen Gang <gang.chen@asianux.com>,
	drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5152980D.8090903@asianux.com>
 <515BE19F.2080709@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <515BE19F.2080709@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 04:00:31PM +0800, Chen Gang wrote:
> Hello maintainers:
> 
>   when you have time, please help to check this patch whether is OK.
> 
>   thanks.

Thanks.

It has already been queued in:
http://git.kernel.dk/?p=linux-block.git;a=commit;h=0b6ef4164f50698eee536903d69d086add1a7889

> On 2013年03月27日 14:56, Chen Gang wrote:
> > 
> >   need remove it, or always return -EBUSY.
> >   it is found by compiler with 'EXTRA_CFLAG=-W'.
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  drivers/block/drbd/drbd_actlog.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
> > index 6afe173..6608076 100644
> > --- a/drivers/block/drbd/drbd_actlog.c
> > +++ b/drivers/block/drbd/drbd_actlog.c
> > @@ -389,7 +389,7 @@ int drbd_al_begin_io_nonblock(struct drbd_conf *mdev, struct drbd_interval *i)
> >  		if (unlikely(tmp != NULL)) {
> >  			struct bm_extent  *bm_ext = lc_entry(tmp, struct bm_extent, lce);
> >  			if (test_bit(BME_NO_WRITES, &bm_ext->flags)) {
> > -				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags));
> > +				if (!test_and_set_bit(BME_PRIORITY, &bm_ext->flags))
> >  					return -EBUSY;
> >  				return -EWOULDBLOCK;
> >  			}
> > 
