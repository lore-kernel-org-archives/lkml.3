Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaF2XQC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 19:16:02 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32542 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaF2XQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 19:16:00 -0400
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Jens <axboe@kernel.dk>, <martin.petersen@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, Kent <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] bio-integrity: add "bip_max_vcnt" into struct bio_integrity_payload
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <53AD4385.8080105@cn.fujitsu.com>
Date: Sun, 29 Jun 2014 19:15:49 -0400
In-Reply-To: <53AD4385.8080105@cn.fujitsu.com> (Gu Zheng's message of "Fri, 27
	Jun 2014 18:12:21 +0800")
Message-ID: <yq1fvin9uje.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Gu" == Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

[Sorry about the delay. I'm on vacation right now.]

Gu> But it seems that bip_integrity_vecs() will return the wrong number
Gu> if the bio is not based on any bio_set for some reason(bio->bi_pool
Gu> == NULL), because in that case, the bip_inline_vecs[0] is malloced
Gu> directly.  So here we add the bip_max_vcnt to record the count of
Gu> vector slots, and cleanup the function bip_integrity_vecs().

I'm in agreement with your fix.

However, I'm still not sure what the use case is for bios without an
associated bioset. I do not see any callers that pass in a NULL bioset.

-- 
Martin K. Petersen	Oracle Linux Engineering
