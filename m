Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaG1SbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:31:17 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:63722 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbaG1SbM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:31:12 -0400
From: Yuval Mintz <Yuval.Mintz@qlogic.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kay Sievers <kay@vrfy.org>,
        "One Thousand Gnomes" <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Pierre Fersing <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Benjamin Poirier <bpoirier@suse.de>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
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
Thread-Index: AQHPqnnzAnxQWE7GzUSaZGTElDLpfpu1n4JQgACJmwCAAAHTAP//o1FT
Date: Mon, 28 Jul 2014 18:30:29 +0000
Message-ID: <B5657A6538887040AD3A81F1008BEC63B07066@avmb3.qlogic.org>
References: <1406558067-25308-1-git-send-email-mcgrof@do-not-panic.com>
 <B5657A6538887040AD3A81F1008BEC63B06F9A@avmb3.qlogic.org>
 <20140728153811.GD21930@wotan.suse.de>
 <B5657A6538887040AD3A81F1008BEC63B06FCF@avmb3.qlogic.org>
 <20140728165248.GE21930@wotan.suse.de>,<20140728165920.GF21930@wotan.suse.de>
In-Reply-To: <20140728165920.GF21930@wotan.suse.de>
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
 engine=7.0.1-1402240000 definitions=main-1407280213
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jul 28, 2014 at 06:52:48PM +0200, Luis R. Rodriguez wrote:
> > On Mon, Jul 28, 2014 at 03:46:32PM +0000, Yuval Mintz wrote:
> > > Sorry for not being clear, but I didn't meant 'what guarantees that the device
> > > will be added to the deferred probe', but rather what guarantees that the
> > > deferred workqueue will be scheduled.
> > >
> > > To the best of my knowledge the deferring mechanism works only if one device
> > > is dependent upon another, e.g., for Multi-function devices where one device
> > > probe is dependent upon the others - which are soon-to-be probed.
> >
> > The workqueue will be kicked when driver_deferred_probe_trigger() gets
> > poked, we do that in the late_initcall(deferred_probe_initcall), it
> > also gets flushed there with a flush_workqueue(deferred_wq).

> But come to think of it that will work well for devices already plugged in
> so indeed I think that driver_deferred_probe_add() needs a check added
> for for if (!driver_deferred_probe_enable) then we have to
> driver_deferred_probe_trigger(). The driver_deferred_probe_enable is set
> to false upon init, but later on late init it gets set to true so with
> that check we'd  only generate the trigger after late init call.

> I can fold that in the v2.

>   Luis

But what about modules being added after the init-calls? If they try try to use this
mechanism, what guarantees they'll eventually get probed?
