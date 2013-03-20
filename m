Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab3CTOvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:51:13 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:7864
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756933Ab3CTOvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:51:10 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.101;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0510HT005.namprd05.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: PS-2(zz98dI936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>,
        "dmitry.kasatkin@intel.com" <dmitry.kasatkin@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "morgan@kernel.org" <morgan@kernel.org>
Subject: Re: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
Thread-Topic: [PATCH 3/4] capability: Create a new capability CAP_SIGNED
Thread-Index: AQHOJXkAAw945khiTkWEZJSmWWl4SJiuqbiA
Date: Wed, 20 Mar 2013 14:50:59 +0000
Message-ID: <1363791059.2553.22.camel@x230.sbx07502.somerma.wayport.net>
References: <1363379758-10071-1-git-send-email-vgoyal@redhat.com>
	 <1363379758-10071-4-git-send-email-vgoyal@redhat.com>
	 <51438EDB.3050300@schaufler-ca.com>
	 <alpine.LRH.2.02.1303201603380.9518@tundra.namei.org>
	 <20130320144110.GF17274@redhat.com>
In-Reply-To: <20130320144110.GF17274@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <022ED67D418A3C44AF69466EE1FC603E@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2KEpEqq032551

On Wed, 2013-03-20 at 10:41 -0400, Vivek Goyal wrote:

> I am not sure why CAP_COMPROMISE_KERNEL(CAP_MODIFY_KERNEL) is any
> different. When secureboot is enabled, kernel will take away that
> capability from all the processes. So kernel became a decision maker
> too whether processes have CAP_COMPROMISE_KERNEL or not based on
> certain other factors like secureboot is enabled or not.

No, that's a limited case. Outside of that, it's an access control
capability in exactly the same way as CAP_SYS_RAWIO is. The easiest way
to think of this is probably whether it ever makes sense for an
arbitrary binary run as root to possess that capability. For
CAP_COMPROMISE_KERNEL the answer is yes - for CAP_SIGNED, the answer is
no.

Just have a flag somewhere in the process structure that indicates
whether it was signed. There's no need to use capabilities here.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
