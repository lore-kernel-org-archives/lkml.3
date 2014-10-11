Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaJKMvq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 08:51:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaJKMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 08:51:41 -0400
To: Petr Vandrovec <petr@vmware.com>
Cc: Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not silently discard WRITE_SAME requests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141011063053.GB18215@petr-dev3.eng.vmware.com>
Date: Sat, 11 Oct 2014 08:51:30 -0400
In-Reply-To: <20141011063053.GB18215@petr-dev3.eng.vmware.com> (Petr
	Vandrovec's message of "Fri, 10 Oct 2014 23:30:53 -0700")
Message-ID: <yq1lhomahwt.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Petr" == Petr Vandrovec <petr@vmware.com> writes:

Petr> After investigating, problem seems to be in a way completion
Petr> handler for WRITE_SAME handles EOPNOTSUPP error, causing
Petr> all-but-first WRITE_SAME request on the LVM device to be silently
Petr> ignored - command is never issued, but success is returned to
Petr> higher layers.

Commit 7eee4ae2dbb2 was meant to address this issue. Does it still
happen with that in place?

-- 
Martin K. Petersen	Oracle Linux Engineering
