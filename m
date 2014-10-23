Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaJWBqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:46:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44924 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaJWBqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:46:53 -0400
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH 2/3] scsi: add try_rc16 blacklist flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141010074901.GA32028@sucs.org>
	<20141010075251.GC32028@sucs.org> <yq1mw8y6sxf.fsf@sermon.lab.mkp.net>
	<20141021042108.GB11691@sucs.org>
Date: Wed, 22 Oct 2014 21:46:32 -0400
In-Reply-To: <20141021042108.GB11691@sucs.org> (Sitsofe Wheeler's message of
	"Tue, 21 Oct 2014 05:21:08 +0100")
Message-ID: <yq1egtzwoav.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sitsofe" == Sitsofe Wheeler <sitsofe@gmail.com> writes:

>> Last time around we identified this as a problem with Microsoft's
>> interpretation of the T10 SBC spec. And they promised that they are
>> going to fix that.

Sitsofe> OK but if we were happy to wait for Microsoft to fix the
Sitsofe> problem on the host why were the (broken and incomplete)
Sitsofe> BLIST_SKIP_VPD_PAGES patches committed to 3.17 rather than
Sitsofe> withdrawn? What's going to be done about those patches now?

There are two orthogonal problems. One being that the driver advertised
conformance to an old SCSI spec. That's being addressed with the
separate SPC-3 patch.

The other issue is that thin provisioning is being incorrectly
advertised. Because that's being addressed by Microsoft and is an
isolated use case I'm hesitant to add quirk for it. Whereas I know
several other devices that will benefit from the TRY_VPD_PAGES blacklist
option.

-- 
Martin K. Petersen	Oracle Linux Engineering
