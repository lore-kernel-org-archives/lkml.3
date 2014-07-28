Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaG1PMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:12:52 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:12656 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbaG1PMv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:12:51 -0400
From: Yuval Mintz <Yuval.Mintz@qlogic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "Tim Gardner" <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Oleg Nesterov" <oleg@redhat.com>, Benjamin Poirier <bpoirier@suse.de>,
        "Nagalakshmi Nandigama" <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        "MPT-FusionLinux.pdl@avagotech.com" 
	<MPT-FusionLinux.pdl@avagotech.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/3] driver core: enable drivers to use deferred probe
 from init
Thread-Topic: [PATCH 1/3] driver core: enable drivers to use deferred probe
 from init
Thread-Index: AQHPqnEWy20DxK5pzkqD80N0dwzvZJu1lkPA
Date: Mon, 28 Jul 2014 15:12:11 +0000
Message-ID: <B5657A6538887040AD3A81F1008BEC63B06F9A@avmb3.qlogic.org>
References: <1406558067-25308-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1406558067-25308-1-git-send-email-mcgrof@do-not-panic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7512 signatures=670489
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407280175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __driver_probe_device(struct device_driver *drv, struct
> +device *dev) {
> +	if (drv->delay_probe && !dev->init_delayed_probe) {
> +		dev_info(dev, "Driver %s requests probe deferral on init\n",
> +			 drv->name);
> +		dev->init_delayed_probe = true;
> +		driver_deferred_probe_add(dev);
> +		return -EPROBE_DEFER;
> +	}
> +
> +	return really_probe(dev, drv);
> +}

Perhaps this is a silly question, but what guarantees that the deferred probe
list will actually be triggered, e.g., in case the delayed device is the last device
in the system?

[From drivers/base/dd.c  - "A successful driver probe will trigger moving all
devices from the pending to the active list so that the workqueue will
eventually retry them]

