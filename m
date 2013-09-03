Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3ICUSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:18:48 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:8339 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab3ICUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:18:46 -0400
Date: Tue, 3 Sep 2013 16:18:28 -0400
From: Chad Dupuis <chad.dupuis@qlogic.com>
To: Yijing Wang <wangyijing@huawei.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 7/7] scsi/qla2xxx: use pcie_is_pcie() to simplify code
In-Reply-To: <1378193715-25328-7-git-send-email-wangyijing@huawei.com>
Message-ID: <alpine.WNT.2.00.1309031617550.7184@N5102REMCQXM4BS.qlogic.org>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com> <1378193715-25328-7-git-send-email-wangyijing@huawei.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
X-X-Sender: cdupuis@qlm.qlogic.com
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Originating-IP: [10.1.4.10]
X-Proofpoint-Virus-Version: vendor=nai engine=5400 definitions=7186 signatures=668647
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1309030065
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>

On Tue, 3 Sep 2013, Yijing Wang wrote:

> Use pci_is_pcie() instead of pci_find_capability
> to simplify code.
>
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: linux-driver@qlogic.com
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> drivers/scsi/qla2xxx/qla_mr.c |    6 ++----
> 1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
> index d799379..5f74271 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -507,7 +507,7 @@ qlafx00_pci_config(scsi_qla_host_t *vha)
> 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
>
> 	/* PCIe -- adjust Maximum Read Request Size (2048). */
> -	if (pci_find_capability(ha->pdev, PCI_CAP_ID_EXP))
> +	if (pci_is_pcie(ha->pdev))
> 		pcie_set_readrq(ha->pdev, 2048);
>
> 	ha->chip_revision = ha->pdev->revision;
> @@ -660,10 +660,8 @@ char *
> qlafx00_pci_info_str(struct scsi_qla_host *vha, char *str)
> {
> 	struct qla_hw_data *ha = vha->hw;
> -	int pcie_reg;
>
> -	pcie_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
> -	if (pcie_reg) {
> +	if (pci_is_pcie(ha->pdev)) {
> 		strcpy(str, "PCIe iSA");
> 		return str;
> 	}
>
