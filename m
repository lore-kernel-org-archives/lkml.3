Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422933AbaGRSVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:21:52 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:17363 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030643AbaGRSVu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:21:50 -0400
From: Rajesh Borundia <rajesh.borundia@qlogic.com>
To: Ethan Zhao <ethan.zhao@oracle.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>
Subject: RE: [PATCH V3] netxen: fix ethtool rx_dropped information in
 ethtool get_ethtool_stats()
Thread-Topic: [PATCH V3] netxen: fix ethtool rx_dropped information in
 ethtool get_ethtool_stats()
Thread-Index: AQHPojqJAk5UETK79kGIRTJKI+qA3ZumI9Mw
Date: Fri, 18 Jul 2014 18:21:44 +0000
Message-ID: <C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
In-Reply-To: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7502 signatures=670482
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407180212
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Ethan Zhao [mailto:ethan.zhao@oracle.com]
> Sent: Friday, July 18, 2014 9:13 AM
> To: Manish Chopra; Sony Chacko; Rajesh Borundia; netdev
> Cc: linux-kernel; ethan.kernel@gmail.com; Ethan Zhao
> Subject: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool
> get_ethtool_stats()
> 
> netxen driver has implemented netxen_nic_get_ethtool_stats() interface,
> but it doesn't collect stats.rxdropped in driver, so we will get different
> rx_dropped statistic information while using ifconfig and ethtool.
> this patch fills stats.rxdropped field with data from net core with
> dev_get_stats() just as ixgbe driver did for some of its stats.

I think ethtool stats are adapter specific. Driver does not maintain
rx_dropped stats and we also don't get it from adapter.  I am not
sure if ethtool stats should match ifconfig stats as ifconfig also
adds net core stats to adapter stats.

If ethtool stats should report same values as ifconfig stats then
we may also need to fix tx_dropped statistics.

Thanks,
Rajesh
