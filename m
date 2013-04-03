Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067Ab3DCNsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:48:39 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:11743
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941Ab3DCNsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:48:37 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Thread-Topic: [PATCH 2/2] efi: Distinguish between "remaining space" and
 actually used space
Thread-Index: AQHOLuuZcipjhSHk/kmF5JR3t+omNZjEe7AAgAAKU4A=
Date: Wed, 3 Apr 2013 13:48:33 +0000
Message-ID: <1364996911.19098.9.camel@x230>
References: <515150EC.7040203@redhat.com>
	 <1364829240-26475-1-git-send-email-matthew.garrett@nebula.com>
	 <1364829240-26475-2-git-send-email-matthew.garrett@nebula.com>
	 <515C2A86.6070606@console-pimps.org>
In-Reply-To: <515C2A86.6070606@console-pimps.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C11D2126FC1FDC408E865A6C492E1806@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r33Dmc9F028513

On Wed, 2013-04-03 at 14:11 +0100, Matt Fleming wrote:

> This looks like something that will differ between implementations, and the
> fact that it's appearing in our code is a sure sign that this isn't the way to
> go.

Our choices right now are:

1) Break machines that don't garbage collect on every reboot
2) Leave Samsungs (and some Lenovos?) vulnerable to bricking
3) Maintain a whitelist or blacklist that will inevitably be inadequate,
either breaking otherwise working machines or risking bricking of broken
ones
4) Attempt to implement something that'll work in all cases

Dealing with firmware is hard. This fixes (1) without leaving us with
(2), which seems like a net win.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
