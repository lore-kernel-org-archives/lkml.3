Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaKFM4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:56:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:51680 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaKFM4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:56:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,325,1413270000"; 
   d="scan'208";a="603421732"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "Fleming, Matt" <matt.fleming@intel.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: RE: [PATCH v2 3/3] efi: Capsule update with user helper interface
Thread-Topic: [PATCH v2 3/3] efi: Capsule update with user helper interface
Thread-Index: AQHP9+iuHUs9oVBcgkKjHBOxgX5ANZxPaE0AgACL8cD//4fqAIAAgjoAgAAK9YCAAAv/gIAAD3kAgANofuA=
Date: Thu, 6 Nov 2014 12:53:54 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B80F3A9@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com>
 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com>
 <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
In-Reply-To: <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA6CuDY6003026

> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Wednesday, November 05, 2014 12:36 AM
> 
> Am I missing something here?  The current proposal is missing the
> success/failure part, unless you count the loaded count (in a different sysfs
> directory) as a useful interface for that.

Here is my sample shell script which allow me to do multi capsule binaries upload
and obtain error message if error occur:

#!/bin/sh

old=$(cat /sys/devices/platform/efi_capsule_user_helper/capsule_loaded)

for arg in "$@"
do
	if [ -f $arg ]
	then
		echo 1 > /sys/class/firmware/efi-capsule-file/loading
		cat $arg > /sys/class/firmware/efi-capsule-file/data
		echo 0 > /sys/class/firmware/efi-capsule-file/loading

		oldtime=$(date +%S)
		oldtime=$(((time + 2) % 60))
		until [ -f /sys/class/firmware/efi-capsule-file/loading ]
		do
			newtime=$(date +%S)
			if [ $newtime -eq $oldtime ]
			then
				break
			fi
		done

		old=$((old + 1))
		new=$(cat /sys/devices/platform/efi_capsule_user_helper/capsule_loaded)
		if [ ! $new -eq $old ]
		then
			echo "Capsule binary $arg upload failed"
			dmesg | tail | grep -v platform | grep -e efi
			exit 1
		fi
	else
		echo "File $arg not found !!"
	fi
done
exit 0


Regards,
Wilson

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
