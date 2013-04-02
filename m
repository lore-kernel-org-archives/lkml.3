Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3DBBs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:48:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11346 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3DBBs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:48:27 -0400
Message-ID: <515A38CB.5030406@huawei.com>
Date: Tue, 2 Apr 2013 09:47:55 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH] PCI/VFIO: use pcie_flags_reg instead of access PCI-E
 Capabilities Register
References: <1364375140-6388-1-git-send-email-wangyijing@huawei.com> <1364829361.2882.26.camel@bling.home>
In-Reply-To: <1364829361.2882.26.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1017,13 +1017,9 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
>>  		return byte;
>>  	case PCI_CAP_ID_EXP:
>>  		/* length based on version */
>> -		ret = pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &word);
>> -		if (ret)
>> -			return pcibios_err_to_errno(ret);
>> -
>>  		vdev->extended_caps = true;
>>  
>> -		if ((word & PCI_EXP_FLAGS_VERS) == 1)
>> +		if ((pdev->pcie_flags_reg & PCI_EXP_FLAGS_VERS) == 1)
> 
> It looks like we should be using pcie_caps_reg(pdev) here instead of
> directly accessing pcie_flags_reg.  Thanks,

That's right, I forget Myron Stowe introduced the PCIe Cap accessor function  pcie_caps_reg().
I will resend the updated patch.

Thanks!
Yijing

> 
> Alex
> 
>>  			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
>>  		else
>>  			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;
> 
> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

