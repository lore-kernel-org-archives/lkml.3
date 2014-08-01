Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaHAKJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 06:09:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59699 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbaHAKJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 06:09:24 -0400
Date: Fri, 1 Aug 2014 18:06:52 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [Query] How to pass reboot arguments to secure firmware with PSCI
 spec
Message-ID: <20140801180652.72e722be@xhacker>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-01_04:2014-08-01,2014-08-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408010129
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin and Will,

I noticed that the following commit implement reboot via. PSCI SYSTEM_RESET
function. So my question is how to handle the reboot arguments? 


> static void psci_sys_reset(enum reboot_mode reboot_mode, const char *cmd)
> {
>       invoke_psci_fn(PSCI_0_2_FN_SYSTEM_RESET, 0, 0, 0);

How to pass cmd to secure firmware?

> }

Thanks in advance,
Jisheng

commit e71246a23acbc89e9cb4ebf1558d60e65733479f
Author: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Date:   Thu Apr 17 14:38:41 2014 -0400

    PSCI: Add initial support for PSCIv0.2 functions
    
    The PSCIv0.2 spec defines standard values of function IDs
    and introduces a few new functions. Detect version of PSCI
    and appropriately select the right PSCI functions.
    
    Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
    Reviewed-by: Rob Herring <robh@kernel.org>
    Acked-by: Catalin Marinas <catalin.marinas@arm.com>
