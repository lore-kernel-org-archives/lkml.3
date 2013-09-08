Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3IHVXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 17:23:33 -0400
Received: from mout2.fh-giessen.de ([212.201.18.46]:52864 "EHLO
	mout2.fh-giessen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IHVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 17:23:32 -0400
From: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
To: imirkin@alum.mit.edu, airlied@linux.ie
Cc: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: 3.12rc1-pre Nouveau? oops
Date: Sun,  8 Sep 2013 23:21:03 +0200
Message-Id: <1378675264-3005-1-git-send-email-tobias.johannes.klausmann@mni.thm.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>
References: <CAKb7UviRb_ao_nB8Q3pa9ePm+yUGd8u7PDREv5wNfCheyGTZjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Looks like you have Optimus (intel + nvidia), and the backtrace has
> runtime pm in it, which is something new Dave added for 3.12, adding
> him in explicitly. The simplest explanation is that disp->init is
> NULL. And it seems like there are no outputs from the earlier nouveau
> init prints. I guess that the call to nouveau_display_resume from
> nouveau_pmops_runtime_resume should be guarded by a if
> (dev->mode_config.num_crtc) like it is everywhere else.
> 
>   -ilia

Your guess was right, this (hopefully attached patch) fixes it for me!

Thanks,
Tobias
