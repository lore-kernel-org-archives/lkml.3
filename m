Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaCQGsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:48:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62041 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaCQGr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:47:59 -0400
X-IronPort-AV: E=Sophos;i="4.97,668,1389715200"; 
   d="scan'208";a="9710116"
Message-ID: <53269B3A.4040900@cn.fujitsu.com>
Date: Mon, 17 Mar 2014 14:50:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Gu Zheng <guz.fnst@cn.fujitsu.com>, viro@zeniv.linux.org.uk,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, miaox@cn.fujitsu.com
Subject: Re: [RESEND v2 PATCH 1/2] aio, memory-hotplug: Fix confliction when
 migrating and accessing ring pages.
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com> <1394439334-28523-2-git-send-email-tangchen@cn.fujitsu.com> <20140311184656.GD16433@kvack.org> <531FEFC6.50709@cn.fujitsu.com> <20140312221735.GF32444@kvack.org> <5322D90C.5050207@cn.fujitsu.com> <20140314151446.GE29206@kvack.org>
In-Reply-To: <20140314151446.GE29206@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/17 14:44:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/17 14:45:00,
	Serialize complete at 2014/03/17 14:45:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 11:14 PM, Benjamin LaHaise wrote:
......
>> What about the following patch? It adds additional reference to protect the page
>> avoid being freed when we reading it.
>> ps.It is applied on linux-next(3-13).
>
> I think that's even worse than the spinlock approach since we'll end up
> bouncing around the struct page's cacheline in addition to spinlock we're
> going to end up taking anyways.
>

Hi Benjamin,

I'm sorry, I don't quite understand the cacheline problem you mentioned 
above.
Would you please explain more ?

Thanks.

