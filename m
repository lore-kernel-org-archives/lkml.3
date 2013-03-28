Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3C1Br6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:47:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40756 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab3C1Br4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:47:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,363,1363104000"; 
   d="scan'208";a="6958619"
Message-ID: <5153A1C7.6030409@cn.fujitsu.com>
Date: Thu, 28 Mar 2013 09:49:59 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] kernel/range.c: subtract_range: fix the broken phrase
 issued by printk
References: <CAE9FiQUrt11A0YAOLgvv3uTAWtTvVg3Mho9eD53orbxW6Jd8Vg@mail.gmail.com> <1363665251-14377-1-git-send-email-linfeng@cn.fujitsu.com> <CAErSpo6DWfHii8d8rGPJ1dLj5TVzsgU7QGDoAvBM5Fb_N5=mtw@mail.gmail.com>
In-Reply-To: <CAErSpo6DWfHii8d8rGPJ1dLj5TVzsgU7QGDoAvBM5Fb_N5=mtw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/28 09:47:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/28 09:47:05,
	Serialize complete at 2013/03/28 09:47:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn and others,

On 03/28/2013 01:27 AM, Bjorn Helgaas wrote:
>> -                               printk(KERN_ERR "run of slot in ranges\n");
>> > +                               pr_err("%s: run out of slot in ranges\n",
>> > +                                       __func__);
>> >                         }
>> >                         range[j].end = start;
>> >                         continue;
> So now the user might see:
> 
>     subtract_range: run out of slot in ranges
> 
> What is the user supposed to do when he sees that?  If he happens to
> mention it on LKML, what are we going to do about it?  If he attaches
> the complete dmesg log, is there enough information to do something?
> 
> IMHO, that message is still totally useless.
> 

Yes, we need to issue some useful message. 
How about dump_stack() there so that we can find some clues more since
subtract_range() is called mtrr_bp_init path and pci relative path, then
it may help to instruct us to do something ;-) ?

thanks,
linfeng
