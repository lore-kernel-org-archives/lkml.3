Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaI2IIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaI2IIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:08:46 -0400
Date: Mon, 29 Sep 2014 13:38:32 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: klondike <klondike@xiscosoft.sinip.es>
cc: linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] initramfs: allow again choice of the embedded compression
 algorithm
In-Reply-To: <54239E69.4050803@klondike.es>
Message-ID: <alpine.LFD.2.10.1409291328290.15448@wniryva.cad.erqung.pbz>
References: <54239E69.4050803@klondike.es>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello Klondike,

+-- On Thu, 25 Sep 2014, klondike wrote --+
| Despite embedding an uncompressed initramfs, a user may want to allow for a
| compressed extra initramfs to be passed using the rd system, for example to
| boot a recovery system. Commit 9ba4bcb645898d562498ea66a0df958ef0e7a68c
| ("initramfs: read CONFIG_RD_ variables for initramfs compression") broke
| that behavior by making the choice based on CONFIG_RD_* instead of adding
| CONFIG_INITRAMFS_COMPRESSION_LZ4. Saddly, CONFIG_RD_* is also used to
| choose the supported RD compression algorithms by the kernel and a user may
| want to suppport more than one.

  Ie. on embedded systems they use CONFIG_INITRAMFS_COMPRESSION_* options to 
compress ram disk and on other platforms they use CONFIG_RD_* options?
 
| As a result the following options are added or readed affecting the embedded
| initramfs compression:
| INITRAMFS_COMPRESSION_NONE Do no compression
| INITRAMFS_COMPRESSION_GZIP Compress using gzip
| INITRAMFS_COMPRESSION_BZIP2 Compress using bzip2
| INITRAMFS_COMPRESSION_LZMA Compress using lzma
| INITRAMFS_COMPRESSION_XZ Compress using xz
| INITRAMFS_COMPRESSION_LZO Compress using lzo
| INITRAMFS_COMPRESSION_LZ4 Compress using lz4

  I haven't tested the patch yet, but does it preserve the CONFIG_RD_* 
options' functionality?

Would unifying the two options into one be a good idea?
--
 - P J P
47AF CE69 3A90 54AA 9045 1053 DD13 3D32 FE5B 041F
