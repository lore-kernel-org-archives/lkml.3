Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3I0SBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:01:20 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:59923 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3I0SBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:01:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
References: <CAGG-pURO7QrMcU1btzh_RvQkLB=4QFqrLntW3n6BeMfU4iFdUQ@mail.gmail.com>
	<CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
Date: Fri, 27 Sep 2013 15:01:16 -0300
Message-ID: <CAGG-pUSiKyXSg7P+XnW965GoVQLib3FdZyCreXS8VDK8cLxnBA@mail.gmail.com>
Subject: Re: [XFS MAINTAINERS] fs/xfs/xfs_dir2_node.c: xfs:
 xfs_dir2_leafn_add: Variables Uninitialized
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maintainers,

I suppose the variables "highstale" and "lowstale" are being used
despite not having been initialized.

File: fs/xfs/xfs_dir2_node.c
Function: xfs_dir2_leafn_add

L491:
> /*
> * Insert the new entry, log everything.
> */
> lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
> highstale, &lfloglow, &lfloghigh);

The only place they are started up is within this condition:

L480:
> if (compact)
> xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
> &highstale, &lfloglow, &lfloghigh);

So, if it is not compact, both have garbage.

Best Regards.

Geyslan Gregório Bem
