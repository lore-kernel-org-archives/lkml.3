Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaEEUOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:14:46 -0400
Received: from mout.gmx.net ([212.227.15.15]:59601 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaEEUOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:14:45 -0400
Date: Mon, 5 May 2014 22:14:36 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net,
        alexandre.f.demers@gmail.com
Subject: Re: [PATCH] staging: rtl8712: fix potential leaks in
 r8712_set_key()
Message-ID: <20140505221436.1522bb3e@spike>
In-Reply-To: <20140504002735.GA16794@kroah.com>
References: <20140501235402.48ced880@spike>
	<20140504002735.GA16794@kroah.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ofVEgRpqrTpOJHHAqGx7YHyBK897Lm1BcK8RDAAcCZWvEXfhhCb
 uVPwaNQ5BQcPQswNCVkSBvM9E+7pCE0tEPTVr4+mwioc9ROyHtpq0qZHq8pTX1hPCzOb5eC
 PL5VgsV+nZn5KQH2CpNRjMFReFufg0ZuMDXsQvJyr0Cp9QedHnKE6ElZvC1JzM/VRUeFQsU
 AgbbRnTCrpLZk7CtmDTEA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2014 20:27:35 -0400, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, May 01, 2014 at 11:54:02PM +0200, Christian Engelmayer wrote:
> > Fix potential leaks in the error paths of r8712_set_key(). In case the
> > algorithm specific checks fail, the function returns without enqueuing
> > or freeing the already allocated command and parameter structs. Use a
> > centralized exit path and make sure that all memory is freed correctly.
> > Detected by Coverity - CID 144370, 144371.
> > 
> > Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> > ---
> > Compile tested and applies against branch staging-next of tree
> > git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> 
> This doesn't apply either, and neither does one of your other patches,
> what is going on?

Greg, I am sorry that last weeks set of staging patches had problems. It
is not my intention to waste Your time.

I could reproduce the issue by running git am on my patches as received
back from the mailing list. Most of the set failed as the mails were split
incorrectly. I started rebasing the patches to the current staging-next
and fixed my mail agents settings to generate no multipart, 7bit text/plain
us-ascii. Thus the same set sent to myself applies now to a fresh clone of
Your tree.


git checkout -b integration-test origin/staging-next 
Branch integration-test set up to track remote branch staging-next from origin.
Switched to a new branch 'integration-test'

git am ./staging.mbox
Applying: staging: binder: fix usage of uninit scalar in binder_transaction()
Applying: staging: comedi: ii_pci20kc: fix usage of uninit scalar in ii20k_attach()
Applying: staging: rtl8188eu: fix potential leak in rtw_set_key()
Applying: staging: rtl8188eu: fix potential leak in rtw_wx_read32()
Applying: staging: rtl8188eu: fix potential leak in update_bcn_wps_ie()
Applying: staging: rtl8712: fix potential leaks in r8712_set_key()
Applying: staging: rtl8723au: Remove unused pointer in rtw_wdev_free()
Applying: staging: rtl8712: fix potential leak in r871x_wx_set_enc_ext()
Applying: staging: silicom: Remove needless calls of get_status_port_fn()
Applying: staging: silicom: Remove unused pointer in bypass_init_module()
Applying: staging: vt6656: fix potential leak in vt6656_hostap_ioctl()
Applying: staging: rtl8188eu: fix potential leak in rtw_wx_set_enc_ext()
Applying: staging: rtl8188eu: fix potential leak in rtw_mp_QueryDrv()
Applying: staging: rtl8188eu: fix potential leak in rtw_mp_SetRFPath()
Applying: staging: rtl8188eu: fix potential leak in rtw_mp_pwrtrk()


> Can you just refresh all of the outstanding patches you have sent me
> that I have not applied and resend them?

Of course. In case there are no objections or further hints, I will check
the refreshed patches later this week when I have got a bit more time and
will resend them.

Regards,
Christian
