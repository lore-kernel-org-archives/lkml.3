Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab3GZMKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:10:30 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40761 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab3GZMKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:10:25 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-21-51f2672eb03a
Message-ID: <51F2672E.2090605@hitachi.com>
Date: Fri, 26 Jul 2013 21:10:22 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Kazuo Ito <kzpn200@gmail.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, kay@vrfy.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Subject: Re: [RESEND RFC PATCH 2/5] printk: add message hash values in /dev/kmsg
 output
References: <20130725083730.20349.50797.stgit@localhost.localdomain> <20130725083730.20349.32762.stgit@localhost.localdomain> <CAEBb_QC3FgBuvnihvj4+xUYKCQX-KnLtW3203GDv-ByiOGsa-g@mail.gmail.com>
In-Reply-To: <CAEBb_QC3FgBuvnihvj4+xUYKCQX-KnLtW3203GDv-ByiOGsa-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2013/07/26 0:01), Kazuo Ito wrote:> Hello, again.
>
> On Thu, Jul 25, 2013 at 5:37 PM, Hidehiro Kawai <
> hidehiro.kawai.ez@hitachi.com> wrote:
>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 8856d74..e2bf2af 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -2153,7 +2153,8 @@ int dev_vprintk_emit(int level, const struct device
>> *dev,
>>
>>         hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
>>
>> -       return vprintk_emit(0, level, hdrlen ? hdr : NULL, hdrlen, fmt,
>> args);
>> +       return vprintk_emit(0, level, hdrlen ? hdr : NULL, hdrlen,
>> +                           fmt, args, NULL);
>>  }
>>  EXPORT_SYMBOL(dev_vprintk_emit);
>>
>
>
>
> Position of struct kmsg_meta * arguments can be made more
> consistent. Because it can occur with va_list which comes
> last by convention, it should be brought to front of these
> lists of arguments. 

You are right.  It should be consistent.

So I will place kmsg_meta * in the front of fmt in the next version.
It would be preferred that the format string immediately followed by
variable arguments.

Regards,
-- 
Hidehiro Kawai
Hitachi, Yokohama Research Laboratory
Linux Technology Center


