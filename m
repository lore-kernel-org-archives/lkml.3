Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3LLHVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:21:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3LLHV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:21:28 -0500
Date: Thu, 12 Dec 2013 12:51:13 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Simon Guinot <simon.guinot@sequanux.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] Read CONFIG_RD_ variables for initramfs compression
In-Reply-To: <20131211154626.GX16823@kw.sim.vm.gnt>
Message-ID: <alpine.LFD.2.10.1312121228540.7044@wniryva.cad.erqung.pbz>
References: <alpine.LFD.2.03.1310152002200.7552@erqung.pbz> <20131029151507.8f63dad8e7525e33431d9596@linux-foundation.org> <alpine.LFD.2.03.1310301226260.12975@erqung.pbz> <20131030150521.ff3fd577a6e506e4278db48c@linux-foundation.org>
 <alpine.LFD.2.03.1310311222150.23774@erqung.pbz> <20131211154626.GX16823@kw.sim.vm.gnt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Simon, Andrew

+-- On Wed, 11 Dec 2013, Simon Guinot wrote --+
| IIUC this patch, the INITRAMFS_COMPRESSION_* options are now
| ignored/useless. Don't you think we should remove them from the
| usr/Kconfig file ?

  -> https://lkml.org/lkml/2013/11/25/21

I'v pushed a patch from Mr Hristo to the same effect. I guess it's still in 
the queue. I haven't received any review for it yet. (...Andrew?)

| Actually, I think this patch makes the initramfs compression
| configuration quite confusing. Consider the following configuration
| for a 3.13-rc3 kernel:
| 
| CONFIG_RD_GZIP=y
| CONFIG_RD_LZMA=y
| CONFIG_INITRAMFS_COMPRESSION_LZMA=y
| 
| This now produces a gzipped initramfs_data.cpio against a lzma one
| previously. 

  That is because, when multiple options are set, CONFIG_RD_GZIP is checked 
last in the usr/Makefile.
  ...
  # Gzip
  suffix_$(CONFIG_RD_GZIP)   = .gz

Hope it helps.
--
Prasad J Pandit / Red Hat Security Response Team
