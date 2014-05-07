Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaEGT6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:58:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:57293 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaEGTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:07 -0400
Date: Wed, 7 May 2014 21:28:25 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: w-lkml@lebenslange-mailadresse.de, gregkh@linuxfoundation.org,
        peter.p.waskiewicz.jr@intel.com, oat.elena@gmail.com,
        linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2 0/5] staging: rtl8188eu: fix Coverity defects in
 os_dep/ioctl_linux.c
Message-ID: <20140507212825.2289e00e@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:oTtX51g2tzPvF/kK3a+ZfHcblUhaO+ZIwOkD2QCXrn6hUYSILLp
 Y35cBYbCAszHtCEaY35eDnvIdf6Ae3X4VghyZy6eieMJ0I77bdYfBUlzT4GIlYt+9oBryqf
 xgfRnrQBVmIs7TuWmSFcW2+wbj9NMhBa5favTAvUHDR3d5+gK9FQ4tMynsHTbmvqfaSRx6q
 7OEsT+dnOY+gwcYEuBpZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup of staging/rtl8188eu/os_dep/ioctl_linux.c regarding Coverity
resource leak findings.

The changes leave the current implementation intact and just attack the problems
in the error paths, however, it seems that we could get easily rid of some of
the mallocs altogether.

   char *input = kmalloc(wrqu->data.length, GFP_KERNEL);
   copy_from_user(input, wrqu->data.pointer, wrqu->data.length);
   qAutoLoad = strncmp(input, "autoload", 8);

v2: Resend after v1 failed to apply

   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
     Remove 'u8 *pbuf' from struct recv_buf)
   * fixed mua: no multipart, 7bit text/plain us-ascii

The series is compile tested and applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Christian Engelmayer (5):
  staging: rtl8188eu: fix potential leak in rtw_wx_read32()
  staging: rtl8188eu: fix potential leak in rtw_wx_set_enc_ext()
  staging: rtl8188eu: fix potential leak in rtw_mp_QueryDrv()
  staging: rtl8188eu: fix potential leak in rtw_mp_SetRFPath()
  staging: rtl8188eu: fix potential leak in rtw_mp_pwrtrk()

 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 69 +++++++++++++++++---------
 1 file changed, 45 insertions(+), 24 deletions(-)

-- 
1.9.1

