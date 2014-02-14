Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaBNH4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:56:53 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63634 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbaBNH4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:56:49 -0500
Date: Fri, 14 Feb 2014 15:54:38 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: use {readl|writel}_relaxed instead of readl/writel in
 i2c-designware-core ?
Message-ID: <20140214155438.4f749a79@xhacker>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-14_02:2014-02-13,2014-02-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402130249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The writel/readl is too expensive especially on Cortex A9 w/ outer L2 cache. This
introduce i2c read/write error on Marvell Berlin SoCs when there are L2 cache
maintenance operations at the same time.

In our internal berlin bsp, we just replaced readl/writel with the relaxed
version. But AFAIK, the "relaxed" version doesn't exist on all architectures. How
to handle this issue? 

Any suggestions are appreciated.

Thanks in advance,
Jisheng
