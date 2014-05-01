Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbaEAFHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 01:07:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58847 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaEAFHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 01:07:46 -0400
Message-ID: <5361D69E.1060802@gmail.com>
Date: Thu, 01 May 2014 07:07:42 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Dave Jones <davej@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, Wei Liu <wei.liu2@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
References: <534F01D1.9000206@gmail.com> <534F858B.4060208@ladisch.de> <53500CDB.8050802@gmail.com> <53570F1F.1000709@gmail.com> <53575099.1030501@gmail.com>
In-Reply-To: <53575099.1030501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


$ file *
linux-3.15.0-0.rc3.git1.10.fc21.i686: directory
linux-3.15.0-0.rc3.git2.1.fc21.i686:  directory
linux-3.15.0-0.rc3.git3.1.fc21.i686:  directory
$
$ grep -R AZX_DCAPS_CORBRP_SELF_CLEAR 
linux-3.15.0-0.rc3.git3.1.fc21.i686/sound/pci/hda/hda_intel.c:	 AZX_DCAPS_CORBRP_SELF_CLEAR)
linux-3.15.0-0.rc3.git3.1.fc21.i686/sound/pci/hda/hda_controller.c:	if (!(chip->driver_caps & AZX_DCAPS_CORBRP_SELF_CLEAR)) {
linux-3.15.0-0.rc3.git3.1.fc21.i686/sound/pci/hda/hda_priv.h:#define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
$ 
$ uname -r
3.15.0-0.rc3.git3.1.fc21.i686  PASSED

Referent commit
ALSA: hda - Suppress CORBRP clear on Nvidia controller chips
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/sound/pci/hda?id=6ba736d

Eye Of The Tiger, Takashi!


poma


