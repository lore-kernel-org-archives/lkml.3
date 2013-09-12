Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab3ILS1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:27:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab3ILS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:27:31 -0400
Date: Thu, 12 Sep 2013 11:27:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/16] 3.11.1-stable review
Message-ID: <20130912182730.GA11890@kroah.com>
References: <20130912181156.173326121@linuxfoundation.org>
 <CA+55aFwN78n92A_mnOve0RsBgHh+o_1KOBvn9d+a2gorXEP6QQ@mail.gmail.com>
 <CA+55aFyiR8ugfFsy3dmofD_G+sPkEqYEQbg2wh7hgXnt-H_Uag@mail.gmail.com>
 <20130912182240.GA10404@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912182240.GA10404@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:22:40AM -0700, Greg Kroah-Hartman wrote:
> On Thu, Sep 12, 2013 at 11:18:40AM -0700, Linus Torvalds wrote:
> > On Thu, Sep 12, 2013 at 11:17 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > Your script may be a bit buggered...
> > 
> > Or maybe I should take that as a sign that 3.11 is doing really well?
> > 
> > I'll be optimistic.
> 
> Hm, something went wrong here, let me track it down...

Ok, that was my fault, was working off of a 'master' branch in a repo
that expected it to be on the linux-3.11.y branch.  Here's the real
pseudo-shortlog below.

And it is short for now, as I've been holding off on applying patches
that are in your tree until 3.12-rc1 comes out.  The patches here are
ones that people have pointed out to me that should go in specifically
for various reasons.  So yes, I do think 3.11 is doing really well, I
have not heard of anything "major" being wrong with it yet.

thanks,

greg k-h


-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.1-rc1

Bing Zhao <bzhao@marvell.com>
    mwifiex: do not create AP and P2P interfaces upon driver loading

Sangjung Woo <sangjung.woo@samsung.com>
    drivers/rtc/rtc-max77686.c: Fix wrong register

John Haxby <john.haxby@oracle.com>
    crypto: xor - Check for osxsave as well as avx in crypto/xor

Fabio Estevam <fabio.estevam@freescale.com>
    imx-drm: imx-drm-core: Export imx_drm_encoder_get_mux_id

Fabio Estevam <fabio.estevam@freescale.com>
    ASoC: fsl: Fix module build

Mark Rusk <Mark.Rusk@hp.com>
    drivers/misc/hpilo: Correct panic when an AUX iLO is detected

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in the handling of channel offers

Wei Hu <wei@aristanetworks.com>
    hwmon: (k10temp) Add support for Fam16h (Kabini)

Graham Williams <gwilli@broadcom.com>
    usb: acm gadget: Null termintate strings table

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: fix hardware reset flow

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix se_cmd->state_list leak regression during WRITE failure

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix potential NULL pointer in solicited NOPOUT reject

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix iscsit_transport reference leak during NP thread reset

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix trailing ASCII space usage in INQUIRY vendor+model


-------------

Diffstat:

 Documentation/hwmon/k10temp               |  1 +
 Makefile                                  |  4 ++--
 arch/x86/include/asm/xor_avx.h            |  4 ++--
 drivers/acpi/ec.c                         |  4 ++++
 drivers/hv/channel_mgmt.c                 | 14 +++++++-------
 drivers/hwmon/Kconfig                     |  4 ++--
 drivers/hwmon/k10temp.c                   |  3 ++-
 drivers/misc/hpilo.c                      |  4 ++--
 drivers/misc/mei/hw-me.c                  |  9 +++------
 drivers/net/wireless/mwifiex/main.c       | 14 --------------
 drivers/rtc/rtc-max77686.c                |  4 ++--
 drivers/staging/imx-drm/imx-drm-core.c    |  1 +
 drivers/target/iscsi/iscsi_target.c       | 17 ++++++++++-------
 drivers/target/iscsi/iscsi_target_login.c |  9 ++++-----
 drivers/target/target_core_spc.c          |  9 ++++++---
 drivers/target/target_core_transport.c    | 11 +++++++++++
 drivers/usb/gadget/f_acm.c                |  1 +
 sound/soc/fsl/Kconfig                     |  4 ++--
 sound/soc/fsl/imx-pcm.h                   |  4 ++--
 19 files changed, 64 insertions(+), 57 deletions(-)


