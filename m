Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3G3SJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:09:52 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:36151 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3G3SJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:09:50 -0400
Message-ID: <51F80167.1080004@fastmail.fm>
Date: Tue, 30 Jul 2013 20:09:43 +0200
From: Bernd Schubert <bernd.schubert@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Nix <nix@esperi.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw,
        stable@vger.kernel.org
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1txjdhree.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: UTF-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 01:34 AM, Martin K. Petersen wrote:
>>>>>> "Nix" == Nix  <nix@esperi.org.uk> writes:
>
> Bernd,
>
> Nix> I can now confirm that reverting this commit causes this problem to
> Nix> go away, and my machine boots fine again.
>
> Can you please send me the output of sq_inq with your 1.49 firmware?
>
> I made a tweak that allowed Nix to boot but we're trying to find a good
> blacklist trigger. And that's tricky given that Areca allows you
> manually specify the SCSI model string for each volume...
>

Sorry it got a bit late today.

Here it is.

> (wheezy)fslab1:~# sg_inq -v /dev/sdc
>     inquiry cdb: 12 00 00 00 24 00
> standard INQUIRY:
>     inquiry cdb: 12 00 00 00 60 00
>   PQual=0  Device_type=0  RMB=0  version=0x05  [SPC-3]
>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=1
>   [RelAdr=0]  WBus16=1  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>   [SPI: Clocking=0x3  QAS=0  IUS=0]
>     length=96 (0x60)   Peripheral device type: disk
>  Vendor identification: Hitachi
>  Product identification: HDS724040KLSA80
>  Product revision level: R001
>     inquiry cdb: 12 01 00 00 fc 00
>     inquiry cdb: 12 01 80 00 fc 00
>  Unit serial number: KRFS2CRAHXJZVD

Besides the firmware, the difference might be that I'm exporting single 
disks without any areca-raidset in between.
I can try to confirm that tomorrow, I just need the system as it is till 
tomorrow noon.


Cheers,
Bernd
