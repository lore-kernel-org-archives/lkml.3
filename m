Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080Ab3CAMhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:37:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39129 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CAMhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:37:15 -0500
Message-ID: <1362141432.3052.28.camel@hornet>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
From: Pawel Moll <pawel.moll@arm.com>
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Fri, 01 Mar 2013 12:37:12 +0000
In-Reply-To: <51308F22.7040303@arm.com>
References: <87wqubkalj.fsf@rustcorp.com.au>
	 <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
	 <513085EA.8070007@arm.com> <1362135005.3052.26.camel@hornet>
	 <51308F22.7040303@arm.com>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 01 Mar 2013 12:37:13.0310 (UTC) FILETIME=[7FE82FE0:01CE1679]
X-MC-Unique: 113030112371305601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 11:21 +0000, Marc Zyngier wrote:
> > Having said that, Rusty was contemplating enforcing LE config space in
> > the new PCI layout...
> 
> I wouldn't complain about that, and would like to see a similar thing on
> MMIO.

Wherever PCI goes, MMIO follows :-)

> Well, it was unclear enough for me to get confused... ;-) It would make
> sense to have a wording similar to the one in the PCI section.

How about this?

8<---------
>From a80f01f15397395a8fc49ef424a2d47c8be0937a Mon Sep 17 00:00:00 2001
From: Pawel Moll <pawel.moll@arm.com>
Date: Fri, 1 Mar 2013 12:35:06 +0000
Subject: [PATCH] virtio-spec: Clarify virtio-mmio configuration space organisation

To clarify potential confusion regarding the configuration
space organisation (endianness in particular) the spec
should clearly state that it follows the PCI device behaviour.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 virtio-spec.lyx |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index a00b675..2fba0b0 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -696,6 +696,17 @@ rproc serial
 
 \begin_layout Section
 Device Configuration
+\change_inserted -875410574 1362141102
+
+\begin_inset CommandInset label
+LatexCommand label
+name "sec:Device-Configuration"
+
+\end_inset
+
+
+\change_unchanged
+
 \end_layout
 
 \begin_layout Standard
@@ -9865,7 +9876,7 @@ a
 
 \change_deleted -875410574 1360838214
 The endianness of the registers follows the native endianness of the Guest.
-\change_inserted -875410574 1360838930
+\change_inserted -875410574 1362141146
 All register values are organized as Little Endian, similarly to the PCI
  variant, see also 
 \begin_inset CommandInset ref
@@ -9875,6 +9886,15 @@ reference "sub:Virtqueue-Endianness"
 \end_inset
 
 .
+ The device-specific configuration space organisation follows the PCI device
+ specification, see
+\begin_inset CommandInset ref
+LatexCommand ref
+reference "sec:Device-Configuration"
+
+\end_inset
+
+.
  
 \change_deleted -875410574 1360838262
  
-- 
1.7.10.4




