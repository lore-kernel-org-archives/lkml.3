Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbaGRSFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:05:50 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:46260 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755885AbaGRSFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:05:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: pigs22_6bcc2b39e7346
X-Filterd-Recvd-Size: 3628
Message-ID: <1405706739.14358.68.camel@joe-AO725>
Subject: Re: [PATCH 0/25] Replace DEFINE_PCI_DEVICE_TABLE macro use
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Benoit Taine <benoit.taine@lip6.fr>, linux-mips@linux-mips.org,
        linux-fbdev@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, linux-acenic@sunsite.dk,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        ath10k@lists.infradead.org, linux-hippi@sunsite.dk,
        industrypack-devel@lists.sourceforge.net, linux-mmc@vger.kernel.org,
        MPT-FusionLinux.pdl@avagotech.com,
        virtualization@lists.linux-foundation.org,
        ath9k-devel@venema.h4ckr.net, wil6210@qca.qualcomm.com,
        linux-pcmcia@lists.infradead.org, linux-can@vger.kernel.org,
        xen-devel@lists.xenproject.org, platform-driver-x86@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        users@rt2x00.serialmonkey.com, e1000-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, devel@linuxdriverproject.org
Date: Fri, 18 Jul 2014 11:05:39 -0700
In-Reply-To: <20140718164340.GA24960@kroah.com>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
	 <20140718162213.GC31114@tuxdriver.com> <20140718164340.GA24960@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 09:43 -0700, Greg KH wrote:
> On Fri, Jul 18, 2014 at 12:22:13PM -0400, John W. Linville wrote:
> > On Fri, Jul 18, 2014 at 05:26:47PM +0200, Benoit Taine wrote:
> > > We should prefer `const struct pci_device_id` over
> > > `DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
> > > This issue was reported by checkpatch.
> >  scripts/checkpatch.pl | 4 ++--
> > Honestly, I prefer the macro -- it stands-out more.  Maybe the style
> > guidelines and/or checkpatch should change instead?
> 
> The macro is horrid, no other bus has this type of thing just to save a
> few characters in typing, so why should PCI be "special" in this regard
> anymore?

I think it doesn't matter much.

The PCI_DEVICE and PCI_VDEVICE macro uses are somewhat similar
and are frequently used with PCI_DEVICE_TABLE, so there's some
commonality there.

The checkpatch message could be made --strict/CHK instead of
WARN so most people would never see it.

Of course it could be removed altogether too.  I don't care.
---
(suggested patch is for -next)

 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index dc72a9b..754fbf2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3018,8 +3018,8 @@ sub process {
 
 # check for uses of DEFINE_PCI_DEVICE_TABLE
 		if ($line =~ /\bDEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=/) {
-			if (WARN("DEFINE_PCI_DEVICE_TABLE",
-				 "Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
+			if (CHK("DEFINE_PCI_DEVICE_TABLE",
+				"Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE\n" . $herecurr) &&
 			    $fix) {
 				$fixed[$fixlinenr] =~ s/\b(?:static\s+|)DEFINE_PCI_DEVICE_TABLE\s*\(\s*(\w+)\s*\)\s*=\s*/static const struct pci_device_id $1\[\] = /;
 			}


