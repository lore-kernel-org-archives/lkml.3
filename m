Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbaGXPzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:55:15 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405AbaGXPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:55:12 -0400
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, apw@canonical.com, jasowang@redhat.com,
        jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
Date: Thu, 24 Jul 2014 11:54:20 -0400
In-Reply-To: <20140724153612.GA23648@sucs.org> (Sitsofe Wheeler's message of
	"Thu, 24 Jul 2014 16:36:12 +0100")
Message-ID: <yq1egxakb0z.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

Sitsofe> So we can see it is really a SATA device that announces discard
Sitsofe> correctly and supports discard through WRITE_SAME(16).

No, that's the SATA device that announces support for DSM TRIM, and as a
result the Linux SATL reports support for WRITE SAME(16) w. the UNMAP
bit set and LBPME.

Sitsofe> It is the act of passing it through Hyper-V that turned it into
Sitsofe> a SCSI device that supports UNMAP (but not WRITE_SAME(16)),
Sitsofe> doesn't announce its SCSI conformance number and doesn't
Sitsofe> correctly announce which features it supports. Surely in this
Sitsofe> case it's reasonable to quirk our way around the problem?

No. That's an issue in Hyper-V that'll you'll have to take up with
Microsoft. I don't know what their passthrough limitations are for
SCSI-ATA translation. Maybe K. Y. has some insight into this?

There must be a reason why the VPD page was added and yet the device not
flagged as LBPME=1.

Many vendors do not support UNMAP/WRITE SAME to DSM TRIM translation.
Additionally, many vendors explicitly only whitelist drives that are
known to be working correctly. Your drive is an ADATA and therefore very
likely to be blacklisted by default by a vendor SATL.

-- 
Martin K. Petersen	Oracle Linux Engineering
