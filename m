Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaDZCvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 22:51:04 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24938 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaDZCvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 22:51:00 -0400
Message-ID: <535B1EB4.3050408@huawei.com>
Date: Sat, 26 Apr 2014 10:49:24 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/13] Refactor pci_is_brdige() to simplify code
References: <1398417515-8740-1-git-send-email-wangyijing@huawei.com> <063D6719AE5E284EB5DD2968C1650D6D0F6FEEB0@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F6FEEB0@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/25 17:42, David Laight wrote:
> From: Yijing Wang
>> This patchset rename the current pci_is_bridge() to pci_has_subordinate(),
>> and introduce a new pci_is_bridge() which determine pci bridge by check
>> dev->hdr_type. The new one is more accurate. PCIe Spec define the pci
>> device is a bridge by the dev->hdr_type = 0x01 || 0x02.
> 
> That is a dangerous rename and is likely to cause difficult to

Hi David,
   I renamed pci_is_bridge() to pci_has_subordinate() because

static inline bool pci_is_bridge(struct pci_dev *pci_dev)
{
	return !!(pci_dev->subordinate);
}

which always check dev->subordinate.

> identify bugs in any code you've missed.

What are you referring to ?


Thanks!
Yijing.






> 
> 	David
> 
> �{.n�+�������+%��lzwm��b�맲��r��zX���w��{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!�iO��z��v�^�m����nƊ��Y&�
> 


-- 
Thanks!
Yijing

