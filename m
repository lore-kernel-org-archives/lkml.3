Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131Ab3D3QUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:20:25 -0400
Received: from mail-bn1lp0155.outbound.protection.outlook.com ([207.46.163.155]:21346
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760997Ab3D3QUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:20:22 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT005.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -1
X-BigFish: PS-1(zz9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahz97hz177df4h17326ah8275bh8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Hyper-V stalls on device errors
Thread-Topic: Hyper-V stalls on device errors
Thread-Index: AQHORbgykjvQZQ533kmaF2QKC1fNjZju72OAgAABhrA=
Date: Tue, 30 Apr 2013 16:17:51 +0000
Message-ID: <8024ef25bbed4216a0ce96ff4318610a@SN2PR03MB061.namprd03.prod.outlook.com>
References: <20130430153321.GA12115@sucs.org>
 <20130430161146.GA15049@sucs.org>
In-Reply-To: <20130430161146.GA15049@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%PARALLELS.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%YAHOO.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(13464002)(199002)(377454001)(189002)(51704004)(47976001)(4396001)(74502001)(74706001)(23726002)(33646001)(47446002)(49866001)(15395725003)(6806003)(47736001)(66066001)(54316002)(46406003)(31966008)(46102001)(15202345002)(69226001)(50986001)(53806001)(65816001)(20776003)(76482001)(56816002)(51856001)(47776003)(59766001)(81342001)(56776001)(74316001)(74662001)(50466002)(63696002)(81542001)(16676001)(1511001)(79102001)(74366001)(80022001)(44976003)(77982001)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB030;H:TK5EX14HUBC103.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 083289FD26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Sitsofe; we will look into this.

Regards,

K. Y

> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@yahoo.com]
> Sent: Tuesday, April 30, 2013 12:12 PM
> To: KY Srinivasan; Haiyang Zhang
> Cc: devel@linuxdriverproject.org; James E.J. Bottomley; linux-
> kernel@vger.kernel.org
> Subject: Re: Hyper-V stalls on device errors
> 
> Apologies for the previous empty mail.
> 
> While testing a Windows 2012 host with a Fedora 18 guest running a 3.9
> kernel I've found that Hyper-v will stall all access to
> (para)virtualised disk devices when an underlying disk device returns an
> error. Every ten seconds a tiny bit of I/O goes through before being
> stalled again and it plays havoc with asynchronous I/O to disk devices
> too.
> 
> To produce this I created a device mapper device with a single error in
> it by using
> 
> dd if=/dev/zero of=/tmp/fakeblock0 bs=100M count=1
> losetup --find --show /tmp/fakeblock0
> # Assuming losetup uses /dev/loop0
> cat << EOF | dmsetup create oneerror
> 0 13443 linear /dev/loop0 0
> 13443 1 error
> 13444 191356 linear /dev/loop0 0
> EOF
> 
> After installing scsi-target-utils the /dev/mapper/oneerror device was
> then turned into a iSCSI target by adding
> 
> <target iqn.2013-04.com.stormagic:oneerror>
>      backing-store /dev/mapper/oneerror
>      write-cache off
> </target>
> 
> to /etc/tgt/targets.conf . The iSCSI target service was started with
> systemctl start tgtd.service (watch out for
> https://bugzilla.redhat.com/show_bug.cgi?id=848942 and you may need to
> disable the firewall by using systemctl stop firewalld.service ).
> 
> The Windows 2012 iSCSI initiator was used to add the target to the
> machine with the hypervisor (the usual discovery should work to the
> Linux box serving the SCSI target). Once done, this disk was then added
> to the Linux guest's Hyper-V settings via the SCSI controller. A spare
> IDE controller disk was also added.
> 
> In the Linux guest a badblock run was started on the spare IDE disk
> block device so that I/O was visible. A
> dd if=/dev/zero of=/dev/sdc oflag=direct
> (where /dev/sdc is the erroring block device that was added earlier) was
> then done to trigger the access of the bad sector.
> 
> The following appeared in dmesg:
> 
> [  160.718836] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
> [  170.991312] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
> [  181.039597] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
> [  191.081242] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
> [  201.116790] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
> [  211.127741] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
> [  221.140338] sd 3:0:0:2: [sdc] Unhandled error code
> [  221.140346] sd 3:0:0:2: [sdc]
> [  221.140349] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  221.140352] sd 3:0:0:2: [sdc] CDB:
> [  221.140354] Write(10): 2a 00 00 00 34 00 00 01 00 00
> [  221.140366] end_request: critical target error, dev sdc, sector 13312
> 
> A Fedora 18 guest on VMWare ESXi returned the error in under a second
> and only had the following in dmesg:
> 
> [  293.917383] sd 2:0:1:0: [sdb] Unhandled sense code
> [  293.917391] sd 2:0:1:0: [sdb]
> [  293.917394] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [  293.917408] sd 2:0:1:0: [sdb]
> [  293.917414] Sense Key : Medium Error [current]
> [  293.917418] sd 2:0:1:0: [sdb]
> [  293.917421] Add. Sense: Unrecovered read error
> [  293.917424] sd 2:0:1:0: [sdb] CDB:
> [  293.917428] Write(10): 2a 00 00 00 34 00 00 04 00 00
> [  293.917436] end_request: critical target error, dev sdb, sector 13312
> 
> The stalls do not occur when the bad block device is created directly in
> the Linux guest.  From the previous log messages it looks like Hyper-V
> is trying for up to a minute before returning an error and the I/O
> stalls to separate (but virtualised) devices on different buses looks
> like an unintended side effect...
> 
> --
> Sitsofe | http://sucs.org/~sits/
> 


