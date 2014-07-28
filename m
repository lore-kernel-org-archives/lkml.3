Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaG1TDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:03:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27310 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1TDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:03:43 -0400
To: KY Srinivasan <kys@microsoft.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering\@suse.com" <ohering@suse.com>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        "jbottomley\@parallels.com" <jbottomley@parallels.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20140724122223.GA31798@sucs.org>
	<yq1iommkgkv.fsf@sermon.lab.mkp.net> <20140724153612.GA23648@sucs.org>
	<yq1egxakb0z.fsf@sermon.lab.mkp.net>
	<16fea5bb87ba47019527cee788e07a72@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq1wqb1gyw1.fsf@sermon.lab.mkp.net>
	<e931486ef33b4e45bfebf2ab1b1b3037@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq17g30dprc.fsf@sermon.lab.mkp.net>
	<cc4a3fd5451242739929d266b88fa8fa@BY2PR0301MB0711.namprd03.prod.outlook.com>
	<yq138dnexcn.fsf@sermon.lab.mkp.net>
	<43306901b1dc4e5dbe014a431e0935ea@BY2PR0301MB0711.namprd03.prod.outlook.com>
Date: Mon, 28 Jul 2014 15:02:46 -0400
In-Reply-To: <43306901b1dc4e5dbe014a431e0935ea@BY2PR0301MB0711.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Mon, 28 Jul 2014 18:50:56 +0000")
Message-ID: <yq11tt5cnmx.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "KY" == KY Srinivasan <kys@microsoft.com> writes:

KY,

KY> "At the time thin-provisioning was defined, the discovery
KY> information was first proposed in READ CAPACITY 16 command. And then
KY> moved into the new dedicated VPD page - B2h. You can see the
KY> information reported in this VPD page is richer than READ CAPACITY
KY> 16 command. As this transition happened during we added the feature,
KY> Windows uses the newer method that based on VPD page B2h. It looks
KY> Linux tries to use both new and old method which is weird to me."

The READ CAPACITY(16) response is not optional.

SBC3r36 section 4.7.3.3 Thin provisioned logical unit:

The device server in a thin provisioned logical unit shall set:

a) the LBPME bit to one in the READ CAPACITY (16) parameter data (see
   5.16.2); and

b) the PROVISIONING TYPE field to 010b (i.e., thin provisioned) in the
   Logical Block Provisioning VPD page (see 6.6.4).

That's a "shall". The LBP VPD elaborates on the provisioning type,
commands preference, etc. But it's all gated by LBPME=1 in the READ
CAPACITY(16) response.

-- 
Martin K. Petersen	Oracle Linux Engineering
