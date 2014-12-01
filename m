Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaLAL5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:57:55 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:40414 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaLAL5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:57:52 -0500
MIME-Version: 1.0
In-Reply-To: <547C41B7.1060604@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<547C41B7.1060604@users.sourceforge.net>
Date: Mon, 1 Dec 2014 14:57:51 +0300
Message-ID: <CALFYKtDBXh=nEegNtBBbVyKw1ynG2g65CQqqJ1EShfa6ZmoMNw@mail.gmail.com>
Subject: Re: [PATCH 1/1] block-rbd: Delete a check before ceph_put_snap_context()
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Alex Elder <elder@kernel.org>, Sage Weil <sage@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>, Ceph <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 1:23 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 1 Dec 2014 11:18:21 +0100
>
> The ceph_put_snap_context() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/block/rbd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 27b71a0..3c34ab5 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3405,8 +3405,7 @@ err_rq:
>         if (result)
>                 rbd_warn(rbd_dev, "%s %llx at %llx result %d",
>                          obj_op_name(op_type), length, offset, result);
> -       if (snapc)
> -               ceph_put_snap_context(snapc);
> +       ceph_put_snap_context(snapc);
>         blk_end_request_all(rq, result);
>  }
>

I squashed it into your "ceph: Deletion of unnecessary checks before two
function calls", which deals with ceph_put_snap_context() in fs/ceph.

Thanks,

                Ilya
