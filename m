Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3APV34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:29:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41681 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab3APV3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:29:55 -0500
Date: Wed, 16 Jan 2013 13:29:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
Message-Id: <20130116132953.6159b673.akpm@linux-foundation.org>
In-Reply-To: <50F647E8.509@jp.fujitsu.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
	<50F440F5.3030006@zytor.com>
	<20130114143456.3962f3bd.akpm@linux-foundation.org>
	<3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
	<20130114144601.1c40dc7e.akpm@linux-foundation.org>
	<50F647E8.509@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 15:25:44 +0900
Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:

> >
> > Things I'm wondering:
> >
> > - is there *really* a case for retaining the boot option if/when
> >    SRAT support is available?
> 
> Yes. If SRAT support is available, all memory which enabled hotpluggable
> bit are managed by ZONEMOVABLE. But performance degradation may
> occur by NUMA because we can only allocate anonymous page and page-cache
> from these memory.
> 
> In this case, if user cannot change SRAT information, user needs a way to
> select/set removable memory manually.

If I understand this correctly you mean that once SRAT parsing is
implemented, the user can use movablecore_map to override that SRAT
parsing, yes?  That movablecore_map will take precedence over SRAT?

