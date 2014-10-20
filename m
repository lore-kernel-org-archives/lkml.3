Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaJTIkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:40:20 -0400
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:21406 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaJTIkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:40:17 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2014 04:40:16 EDT
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:CC:
   Date:Subject:Thread-Topic:Thread-Index:Message-ID:
   References:In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version;
  b=obf/AtNOUYxg0mmjVmBuJcHrkjjKJZLbMWqfEl+NAg3FK9CxlGVW6qT4
   C5nat6bFOSmCpxRKs72+wczE5zDJSC+ayYV3ZZFyIHl9iRB/+Fx+un6PG
   273MAimoWyLWzUe1ZjmM2VGhFzvB624Va+jsCzDqdt76WBoD/+onm+uxe
   8pbvDIxf04GFFeyWzVj+xZY4pjmGOfHvvpGAaMLqo/auNjGAbQQf31My7
   tEVQLDN3tslpZffM8YEwPFy3rjWlU;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="5.04,754,1406584800"; 
   d="scan'208";a="210471421"
From: "Wilck, Martin" <martin.wilck@ts.fujitsu.com>
To: "minyard@acm.org" <minyard@acm.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
        "trenn@suse.de" <trenn@suse.de>
Date: Mon, 20 Oct 2014 10:28:53 +0200
Subject: Re: [patch 1/3] ipmi: Setup ipmi_devintf automatically if
 ipmi_msghandler gets loaded
Thread-Topic: [patch 1/3] ipmi: Setup ipmi_devintf automatically if
 ipmi_msghandler gets loaded
Thread-Index: Ac/sP+J9Le/xmE5WTJSx7HOH58MZ0w==
Message-ID: <1413793733.2678.10.camel@pdbcooper.pdb.fsc.net>
References: <20141014144020.683892494@d46.suse.de>
	 <20141014144315.178850163@d46.suse.de> <543DCC4C.3090404@acm.org>
	 <27197467.RMEiFLZMHQ@d46> <54414057.5020806@acm.org>
In-Reply-To: <54414057.5020806@acm.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9K8eN3M023071

On Fri, 2014-10-17 at 18:14 +0200, Corey Minyard wrote:

> How about this.  I did a little research, and there's something called soft
> module dependencies.  Apparently you can add:
> 
> MODULE_SOFTDEP("post: ipmi_devintf")
> 
> to ipmi_msghandler.c and modprobe would load ipmi_devintf after loading
> ipmi_msghandler if it was available.

This is nice, but not commonly available in distro kernels so far.
AFAICS, out of the distros Fujitsu supports, only RHEL7 supports it.

I vote for MODULE_SOFTDEP for upstream, and modalias for distros that
don't support MODULE_SOFTDEP yet.

Martin


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
