Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab3APWxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:53:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59326 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681Ab3APWxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:53:31 -0500
Message-ID: <50F72F17.9030805@zytor.com>
Date: Wed, 16 Jan 2013 14:52:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "lliubbo@gmail.com" <lliubbo@gmail.com>,
        "jaegeuk.hanse@gmail.com" <jaegeuk.hanse@gmail.com>,
        "glommer@parallels.com" <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com> <50F440F5.3030006@zytor.com> <20130114143456.3962f3bd.akpm@linux-foundation.org> <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com> <20130114144601.1c40dc7e.akpm@linux-foundation.org> <50F647E8.509@jp.fujitsu.com> <20130116132953.6159b673.akpm@linux-foundation.org>
In-Reply-To: <20130116132953.6159b673.akpm@linux-foundation.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 01:29 PM, Andrew Morton wrote:
>>
>> Yes. If SRAT support is available, all memory which enabled hotpluggable
>> bit are managed by ZONEMOVABLE. But performance degradation may
>> occur by NUMA because we can only allocate anonymous page and page-cache
>> from these memory.
>>
>> In this case, if user cannot change SRAT information, user needs a way to
>> select/set removable memory manually.
> 
> If I understand this correctly you mean that once SRAT parsing is
> implemented, the user can use movablecore_map to override that SRAT
> parsing, yes?  That movablecore_map will take precedence over SRAT?
> 

Yes, but we still need a higher-level user interface which specifies
which nodes, not which memory ranges, should be movable.  That is the
policy granularity that is actually appropriate for the administrator
(trading off performance vs reliability.)

	-hpa

