Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKZE51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:57:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44830 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaKZE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:57:25 -0500
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] block: fix regression where bio_integrity_process uses wrong bio_vec iterator
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141126014025.GD10050@birch.djwong.org>
Date: Tue, 25 Nov 2014 23:57:18 -0500
In-Reply-To: <20141126014025.GD10050@birch.djwong.org> (Darrick J. Wong's
	message of "Tue, 25 Nov 2014 17:40:25 -0800")
Message-ID: <yq161e2sgnl.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

Darrick> Therefore, teach bio_integrity_process() to use
Darrick> bio_for_each_segment() to iterate the bio_vecs, since the
Darrick> per-bio iterator tracks which bio_vecs are associated with that
Darrick> particular bio.  The integrity handling code is effectively
Darrick> part of the "driver" (it's not the bio owner), so it must use
Darrick> the correct iterator function.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
