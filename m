Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaDYJCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:02:13 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:1553 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbaDYJCK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:02:10 -0400
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Dept-HSG Linux NIC Dev <Dept-HSGLinuxNICDev@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Index: AQHPYF0YARZHvVJuFEOYwJzqBE222ZsiA45AgAB6rgD//4pfcA==
Date: Fri, 25 Apr 2014 09:02:02 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F9EEA2@avmb2.qlogic.org>
References: <cover.1398412015.git.agordeev@redhat.com>
 <0a0d5f5c33d86e3777c22c3c1bbd81035660d57c.1398412015.git.agordeev@redhat.com>
 <262CB373A6D1F14F9B81E82F74F77D5A46F9EE54@avmb2.qlogic.org>
 <20140425090029.GA2500@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140425090029.GA2500@dhcp-26-207.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7418 signatures=670421
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1404250150
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Friday, April 25, 2014 2:31 PM
> To: Shahed Shaikh
> Cc: linux-kernel; Dept-HSG Linux NIC Dev; netdev; linux-pci
> Subject: Re: [PATCH net-next 2/2] qlcnic: Use pci_enable_msix_exact()
> instead of pci_enable_msix()
> 
> On Fri, Apr 25, 2014 at 08:48:14AM +0000, Shahed Shaikh wrote:
> > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> > > b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> > > index dbf7539..26f022b 100644
> > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> > > @@ -690,8 +690,8 @@ int qlcnic_setup_tss_rss_intr(struct
> > > qlcnic_adapter
> > > *adapter)
> > >  		adapter->msix_entries[vector].entry = vector;
> > >
> > >  restore:
> > > -	err = pci_enable_msix(pdev, adapter->msix_entries, num_msix);
> > > -	if (err > 0) {
> > > +	err = pci_enable_msix_exact(pdev, adapter->msix_entries,
> > > num_msix);
> > > +	if (err == -ENOSPC) {
> > >  		if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
> > >  			return -ENOSPC;
> >
> > I think, it would be good if we return "err" instead of "-ENOSPC" .
> >
> >                 if (!adapter->drv_tss_rings && !adapter->drv_rss_rings)
> > -                       return -ENOSPC;
> > +                       return err;
> 
> At this point "err" could only be -ENOSPC. I am not sure why returning "err" is
> better, but I'll repost if you insist.

Agree. But it will make code look cleaner.

Thanks,
Shahed
