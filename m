Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbaDKPRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:17:18 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43436 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaDKPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:17:16 -0400
Date: Fri, 11 Apr 2014 08:17:15 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: "Yan, Zheng" <ukernel@gmail.com>
cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>, yehuda@inktank.com,
        elder@kernel.org, ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
In-Reply-To: <CAAM7YA=CwbM8Hgh+QFMoGP1RLaA1drwabG_O2sOqCOcg_Wv+fg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1404110817110.16913@cobra.newdream.net>
References: <1397205492-24447-1-git-send-email-duanj.fnst@cn.fujitsu.com> <CAAM7YA=CwbM8Hgh+QFMoGP1RLaA1drwabG_O2sOqCOcg_Wv+fg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks!

sage

On Fri, 11 Apr 2014, Yan, Zheng wrote:

> On Fri, Apr 11, 2014 at 4:38 PM, Duan Jiong <duanj.fnst@cn.fujitsu.com> wrote:
> > This patch fixes coccinelle error regarding usage of IS_ERR and
> > PTR_ERR instead of PTR_ERR_OR_ZERO.
> >
> > Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> > ---
> >  drivers/block/rbd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 4c95b50..552a2ed 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -4752,7 +4752,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
> >
> >                 image_id = ceph_extract_encoded_string(&p, p + ret,
> >                                                 NULL, GFP_NOIO);
> > -               ret = IS_ERR(image_id) ? PTR_ERR(image_id) : 0;
> > +               ret = PTR_ERR_OR_ZERO(image_id);
> >                 if (!ret)
> >                         rbd_dev->image_format = 2;
> >         } else {
> 
> Reviewed-by: Yan, Zheng <zheng.z.yan@intel.com>
> 
> > --
> > 1.8.3.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
