Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718AbaFCUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:52:49 -0400
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:51414 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaFCUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:52:48 -0400
X-MXL-Hash: 538e35a07bb2d97d-39be567d59a5e7ce89d36df50bc2afad17ecee7f
X-MXL-Hash: 538e2e355000d7f3-ea6cbf335e862987fe6ebf71a8ac81ddd6054a1a
Date: Tue, 3 Jun 2014 16:21:00 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Jeff Moyer <jmoyer@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block,scsi: convert and handle ERR_PTR from
 blk_get_request
Message-ID: <20140603162100.7fad1506@jlaw-desktop.mno.stratus.com>
In-Reply-To: <x49r435vktb.fsf@segfault.boston.devel.redhat.com>
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
	<1401396529-17275-3-git-send-email-joe.lawrence@stratus.com>
	<x49r435vktb.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AnalysisOut: [v=2.1 cv=B9Q30YdM c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=jt-5_Eo0nRcA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=20KFwNOVAAAA:8 a=TSbVqHtbAAAA:8]
X-AnalysisOut: [ a=OGrwO1VU57KFerL8gDcA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA]
X-AnalysisOut: [:10 a=kSViFEBMy1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014060324); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 15:45:36 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Joe Lawrence <joe.lawrence@stratus.com> writes:
> 
> > The blk_get_request function may fail in low-memory conditions or during
> > device removal (even if __GFP_WAIT is set). To distinguish between these
> > errors, modify the blk_get_request call stack to return the appropriate
> > ERR_PTR. Verify that all callers check the return status and consider
> > IS_ERR instead of a simple NULL pointer check.
> 
> I'm curious to know what testing you did, and what code paths do
> anything different for ENOMEM vs EIO.  I guess ENOMEM may make it all
> the way back to userspace?

Hi Jeff,

Good question.  In the case of the short repro program provided by
Paolo in [1], the ioctl call returned error and set -ENODEV.

As for each individual caller of blk_get_request, I did not audit all
code paths back out to user space.  I can take a look, but I'm guessing
that 24-ish callers might make for quite a *few* scenarios to verify.

Conversion to ERR_PTR was suggested by Jens as a complete fix, but
without sufficient Ack's, I can understand holding off on this part of
the set.

-- Joe

[1] http://thread.gmane.org/gmane.linux.scsi/85824
