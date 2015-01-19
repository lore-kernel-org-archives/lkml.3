Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbbASDTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 22:19:33 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:10694 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbbASDTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 22:19:31 -0500
Message-ID: <54BC772E.6020103@huawei.com>
Date: Mon, 19 Jan 2015 11:17:02 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-m68k@vger.kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        <linux-alpha@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>, Yinghai Lu <yinghai@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 18/28] PCI/sparc: Use pci_scan_root_bridge() for simplicity
References: <1421372666-12288-1-git-send-email-wangyijing@huawei.com> <1421372666-12288-19-git-send-email-wangyijing@huawei.com> <2658988.B0VmbMPdJ9@wuerfel>
In-Reply-To: <2658988.B0VmbMPdJ9@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54BC7743.0013,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 4fe34d0b696de2a0712b95d78de6cb07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/16 18:01, Arnd Bergmann wrote:
> On Friday 16 January 2015 09:44:16 Yijing Wang wrote:
>> +static void pci_host_bridge_probe_mode(
>> +               struct pci_host_bridge *host)
>> +{
>> +       host->of_scan = true;
>> +}
>>
> 
> I probably missed something here, but where does host->of_scan
> get used?
> 

It is used in __pci_scan_root_bus() to detect whether of scan bus is needed in patch 11.


@@ -2051,10 +2053,17 @@ static struct pci_bus *__pci_scan_root_bus(
 		pci_bus_insert_busn_res(b, host->busnum, 255);
 	}

-	max = pci_scan_child_bus(b);
+	if (host->ops && host->ops->phb_probe_mode)
+		host->ops->phb_probe_mode(host);

-	if (!found)
-		pci_bus_update_busn_res_end(b, max);
+	if (host->of_scan) {
+		if (host->ops &&host->ops->phb_of_scan_bus)
+			host->ops->phb_of_scan_bus(host);
+	} else {
+		max = pci_scan_child_bus(b);
+		if (!found)
+			pci_bus_update_busn_res_end(b, max);
+	}

 	return b;

Thanks!
Yijing.


> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> .
> 


-- 
Thanks!
Yijing

