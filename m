Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3EFQgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 12:36:52 -0400
Received: from mail.datasphere.ch ([195.70.3.149]:35177 "EHLO
	mail.datasphere.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3EFQgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 12:36:50 -0400
X-Account-Key: account1
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
FCC: imap://pm@mail.datasphere.ch/Sent
X-Identity-Key: id1
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0
Content-class: urn:content-classes:message
Subject: Re: [PATCH 1/1] Create megaraid ioctl device node
Date: Mon, 6 May 2013 18:36:27 +0200
Message-ID: <AB5E58B87EB73C46A38073D8F459F113D9FBA9@dataspheresrv01>
In-Reply-To: <87a9o86vbj.fsf@nemi.mork.no>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] Create megaraid ioctl device node
Thread-Index: Ac5Kd9sMtEuohFYiRHi0RBu9AlBUwA==
References: <AB5E58B87EB73C46A38073D8F459F113D9FBA4@dataspheresrv01> <87a9o86vbj.fsf@nemi.mork.no>
From: "Patrick Monnerat" <Patrick.Monnerat@datasphere.ch>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
Cc: "Neela Syam Kolli" <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r46GawR5024981

On 05/06/2013 04:23 PM, BjÃ¸rn Mork wrote:
> "Patrick Monnerat" <Patrick.Monnerat@datasphere.ch> writes:
>>    Create ioctl device node for megaraid_sas driver. Let this node be
>> managed by udev. Fix a typo.
>
> Or maybe just simplify it all and use a misc device instead?  See how
> this is done in e.g. drivers/scsi/mpt3sas/mpt3sas_ctl.c or
> drivers/message/fusion/mptctl.c

Yes, could be done that way, but I want to retain compatibility with 
existing shell scripts doing things like:


DEVICE=/dev/megaraid_sas_ioctl_node
DEVICENAME=megaraid_sas_ioctl
DEVICEPERM=400
MAJOR=`grep "$DEVICENAME" /proc/devices | awk '{print $1}'`

if [ -n "$MAJOR" -a ! -e "$DEVICE" ]; then
     mknod "$DEVICE" c "$MAJOR" 0
     chmod "$DEVICEPERM" "$DEVICE"
fi

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
