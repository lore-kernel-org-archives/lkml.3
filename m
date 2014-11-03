Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaKCUKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:10:08 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:62681 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbaKCUKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:10:04 -0500
Date: Mon, 3 Nov 2014 15:09:47 -0500
From: Chad Dupuis <chad.dupuis@qlogic.com>
X-X-Sender: cdupuis@administrators-macbook-pro.local
To: Meelis Roos <mroos@linux.ee>
CC: Joe Carnuccio <joe.carnuccio@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>, <qla2xxx-upstream@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: bisected regression: qla2xxx endianness on sparc64
In-Reply-To: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
Message-ID: <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Originating-IP: [10.1.4.10]
disclaimer: bypass
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7611 signatures=670571
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1411030175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2 Nov 2014, Meelis Roos wrote:

> Between 3.17 and 3.18-rc2, qla2xxx is broken on my sparc64 machines. It fails 
> to boot (hangs in firmware rings init).
>
> This is the result of bisect:
>
> 98aee70d19a7e3203649fa2078464e4f402a0ad8 is the first bad commit
> commit 98aee70d19a7e3203649fa2078464e4f402a0ad8
> Author: Joe Carnuccio <joe.carnuccio@qlogic.com>
> Date:   Thu Sep 25 05:16:38 2014 -0400
>
>    qla2xxx: Add endianizer to max_payload_size modifier.
>
>    Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
>    Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>    Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> :040000 040000 041c1a26dc2a7988900acc982e3bd65d3cf7e751 
> 9700d09c3226fc352d44352f22b84f1be632d324 M  s
>
> This may not be the only problem - when bisecting, I also came to commits 
> that got past this step but hang after about 165 seconds of uptime while 
> running userspace startup scripts. But let that be another issue at the 
> moment.
>

We should revert that change. What were some of the other failures you 
were seeing?
