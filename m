Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaBAO2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:28:20 -0500
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:35316
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933102AbaBAO2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:28:18 -0500
Message-ID: <52ED010E.80500@myricom.com>
Date: Sat, 1 Feb 2014 23:13:34 +0900
From: Hyong-Youb Kim <hyong-youb.kim@myricom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: Hyong-Youb Kim <hykim@myri.com>, <netdev@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 20/34] myri10ge: Use pci_enable_msix_range()
References: <cover.1391172839.git.agordeev@redhat.com> <1253b3c920637ab6bb987defb88d1698ac1e4851.1391172839.git.agordeev@redhat.com> <52EBF885.30309@cogentembedded.com>
In-Reply-To: <52EBF885.30309@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [125.132.7.245]
X-ClientProxiedBy: SIXPR03CA019.apcprd03.prod.outlook.com (10.141.119.29) To
 BY2PR04MB062.namprd04.prod.outlook.com (10.242.34.19)
X-Forefront-PRVS: 0109D382B0
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(6049001)(199002)(189002)(24454002)(51704005)(377454003)(479174003)(53806001)(63696002)(42186004)(81816001)(94316002)(54356001)(74366001)(23756003)(36756003)(81686001)(93516002)(87266001)(81542001)(79102001)(47776003)(64126003)(86362001)(87976001)(76786001)(76796001)(85852003)(92726001)(49866001)(47736001)(47976001)(50986001)(4396001)(90146001)(94946001)(77096001)(66066001)(65956001)(65806001)(56816005)(83072002)(80022001)(92566001)(46102001)(81342001)(33656001)(74706001)(74502001)(74662001)(83506001)(47446002)(31966008)(59766001)(69226001)(50466002)(83322001)(77982001)(51856001)(85306002)(56776001)(54316002)(74876001)(80976001)(76482001)(93136001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR04MB062;H:[192.168.0.3];CLIP:125.132.7.245;FPR:7E05F462.8EF047C5.B26A72CB.4462579.20170;InfoNoRecordsA:0;MX:1;LANG:en;
X-OriginatorOrg: myricom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/1/2014 4:24 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 01/31/2014 06:08 PM, Alexander Gordeev wrote:
>
[...]
>> +        if (status < 0)
>> +            goto disable_msix;
>
>     Hm, if enabling MSI failed, we don't need to disable it, right? So,
> perhaps the label should be renamed?
>

The code following disable_msix does not call pci_disable_msix().  It 
frees the allocated vector buffer and loads the firmware that uses a 
single interrupt vector.  So, it is "disable" in the sense that the 
driver is not going to use MSI-X vectors.  I agree that naming could be 
better.

disable_msix:
         if (mgp->msix_vectors != NULL) {
                 kfree(mgp->msix_vectors);
                 mgp->msix_vectors = NULL;
         }

abort_with_fw:
         mgp->num_slices = 1;
         set_fw_name(mgp, old_fw, old_allocated);
         myri10ge_load_firmware(mgp, 0);
