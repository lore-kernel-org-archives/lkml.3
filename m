Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3FMRsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:48:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63481 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3FMRs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:48:29 -0400
Date: Thu, 13 Jun 2013 18:48:25 +0100
From: Gustavo Padovan <gustavo@padovan.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-06-13
Message-ID: <20130613174825.GA28084@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20130613112228.GB17870@joana>
 <20130613171711.GB3246@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613171711.GB3246@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

* John W. Linville <linville@tuxdriver.com> [2013-06-13 13:17:12 -0400]:

> On Thu, Jun 13, 2013 at 12:22:28PM +0100, Gustavo Padovan wrote:
> > Hi John,
> > 
> > A few important fixes to 3.10. The first one is a crash fix and talks by itself.
> > Then we have the support for a device id, it should be fine if you want to
> > remove this. Next there are two btmrvl fixes, one for a potential race
> > condition that could make its main thread never stop and the other to fix the
> > return code when a memory allocation fails. It was returning 0 instead of
> > -ENOMEM. Last is a fix to an issue that affects at least some Thinkpad X60,
> > Initialization on those laptops were failing due by unsupported cmd we were
> > sending to the device. The patch fixes this by checking if the cmd is
> > supported first.
> > 
> > Please pull or let me know of any concerns you may have.
> > 
> > 	Gustavo
> > 
> > ---
> > The following changes since commit d90b9e29ec5fe7a08eb7965386ebb47615306584:
> > 
> >   Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2013-06-12 14:28:21 -0400)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> > 
> > for you to fetch changes up to 0e1aba9361bf292fbdca781d419dca67d6b9911f:
> > 
> >   Bluetooth: btmrvl: fix thread stopping race (2013-06-13 11:48:38 +0100)
> > 
> > ----------------------------------------------------------------
> 
> I applied these manually to the wireless tree:
> 
> > Anderson Lizardo (1):
> >       Bluetooth: Fix crash in l2cap_build_cmd() with small MTU
> > 
> > Daniel Drake (1):
> >       Bluetooth: btmrvl: fix thread stopping race
> > 
> > Johan Hedberg (1):
> >       Bluetooth: Fix conditions for HCI_Delete_Stored_Link_Key
> 
> These I will manually apply to wireless-next:
> 
> > Cho, Yu-Chen (1):
> >       Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]
> > 
> > Wei Yongjun (1):
> >       Bluetooth: btmrvl: fix error return code in btmrvl_sdio_card_to_host()
> 
> The device ID one might be OK, but it can wait for now.  The error
> return code patch fixes the return code for a function whose return
> code isn't actually checked, so it doesn't seem to need a quick fix.

Oh, I missed that when applied this patch! Thanks a lot for pushing the
patches, I'll update the bluetooth trees accordingly.

	Gustavo
