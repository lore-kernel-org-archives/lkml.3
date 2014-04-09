Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbaDIVdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:33:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:59519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933717AbaDIVdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,828,1389772800"; 
   d="scan'208";a="517805956"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Jason Baron <jbaron@akamai.com>
CC: Aristeu Rozanski <aris@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] ie31200_edac: Add driver
Thread-Topic: [PATCH 3/3] ie31200_edac: Add driver
Thread-Index: AQHPUErabVWTFTq13UyiP3ii3SIN9psJpHwAgAAhKgD//8g+EIAAe16AgAAWkYCAAATpAIAACuCAgAAGRID//5pcUA==
Date: Wed, 9 Apr 2014 21:33:10 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31E2358F@ORSMSX106.amr.corp.intel.com>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140409113552.GJ6529@pd.tnic> <20140409133433.GJ29214@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
 <20140409173633.GN6529@pd.tnic> <5345980F.7070604@akamai.com>
 <20140409191454.GQ6529@pd.tnic> <5345A54D.2050808@akamai.com>
 <20140409201615.GS6529@pd.tnic>
In-Reply-To: <20140409201615.GS6529@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s39LXM0b022156

> Unfortunately, the box reporting the ue errors just went into transit (so
> that I can better examine this issue), so I will probably not be able to
> run this experiment on that specific box until next week.

Do you have any other logs from this machine.  Is there something
logged in one (or more) of the machine check banks when your EDAC
driver says that there are uncorrected errors?

When the box is back  online again - I'd be interested to know if mcelog(8)
daemon reports any errors.   Grab the latest from mcelog.org, compile
and run as "mcelog --daemon".  Logs show up in /var/log/mcelog

> # ./rdmsr 0x179
> c09

So this processor does support CMCI - next question is whether each
bank support it (and got enabled by Linux) [can run on any system ... don't
need to wait for the one to finish transit)]

# for I in `seq 0 8`
do
       ./rdmsr 0x28$i
done

will print the MCi_CTL2 registers from each bank. Bit 30 (0x40000000)
shows CMCI enabled.

On the name of the driver - can you throw in an underscore: ie3_12xx.c ?

Do you have systems from Sandy Bridge, Ivy Bridge and Haswell generations
(no suffix for Sandy Bridge, then v2 and v3) ... and does this driver work across all of
them?  If it is just for Haswell ... then "ie3_12xx_v3.c" might be a better name.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
