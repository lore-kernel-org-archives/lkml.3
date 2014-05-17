Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaEQS4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 14:56:43 -0400
Received: from mout.gmx.net ([212.227.17.20]:64162 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaEQS4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 14:56:42 -0400
Date: Sat, 17 May 2014 20:56:35 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Jes.Sorensen@redhat.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/2] staging: rtl8188eu: fix usage of uninit scalar in
 rtw_drv_init()
Message-ID: <20140517205635.22c40685@spike>
In-Reply-To: <20140517144423.GA15585@mwanda>
References: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
	<1400323138-32243-2-git-send-email-cengelma@gmx.at>
	<20140517144423.GA15585@mwanda>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:QfCOU27PeShXtvopVKWleVdNuMIeHAiR7Hg6qcjSNbN0bHgnOI+
 ShiYsJ4XohGfpuD2ch/mbQ0N77SV2LnDyg9QhxiTiPClcjUyAUojfM689j957ACpGHkAj5j
 HZt1fgyptt+JBNn9OF5afTQiDyINndSQ+izccgn3/TtYf9GVZ/eo4Ivrf9Ek7EJhLEBo4ar
 8yrA+aES3LzsMHfRS8QSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014 17:44:23 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Sat, May 17, 2014 at 12:38:57PM +0200, Christian Engelmayer wrote:
> > Function rtw_drv_init() is written in a way that assumes 'status' != _SUCCESS
> > as long as not explicitly set. Thus initialize 'status' to FAIL, in order to
> > prevent undefined behaviour if going through the exit paths. Detected by
> > Coverity - CID 1077832.
> > 
> > Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> 
> This is a bugfix and we like to merge bugfixes without asking redo
> things, so don't redo.  But really the better fix is to get rid of the
> status variable completely.  Just return directly on the success path.
> 
> If we were to do that, then both patches would be merged together and
> called:  [patch] Staging: rtl8188eu: fix error handling in rtw_drv_init()
> 
> But this patch is also acceptable as-is.  Thanks for fixing the bug.  :)

I agree with You Dan. I'm no big fan of that status variable either. In this
case I was already tempted, but saw it as a recurring pattern in that file
in case cleanup is done. So I decided to just attack the bug in a small change
and leave the cleanup of the error handling pattern for a later, consistent
sweep over the whole file if that's wanted.

Regards,
Christian
