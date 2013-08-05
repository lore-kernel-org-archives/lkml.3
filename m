Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab3HENYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:24:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3HENYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:24:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,818,1367942400"; 
   d="scan'208";a="8123116"
Message-ID: <51FFA748.50800@cn.fujitsu.com>
Date: Mon, 05 Aug 2013 21:23:20 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: robert.moore@intel.com, lv.zheng@intel.com, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 05/18] x86, ACPICA: Split acpi_boot_table_init()
 into two parts.
References: <1375434877-20704-1-git-send-email-tangchen@cn.fujitsu.com> <7364455.HW1C4G1skW@vostro.rjw.lan> <51FF1A4F.1050309@cn.fujitsu.com> <2500845.tndtCsERty@vostro.rjw.lan>
In-Reply-To: <2500845.tndtCsERty@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 21:23:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 21:23:24,
	Serialize complete at 2013/08/05 21:23:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 08/05/2013 09:26 PM, Rafael J. Wysocki wrote:
......
>
> I think I understand what you're trying to achieve and I don't have objections
> agaist the goal, but the matter is *how* to do that.
>
> Why don't you do something like this:
> (1) Introduce two new functions that will each do part of
>      acpi_tb_parse_root_table() such that calling them in sequence, one right
>      after the other, will be exactly equivalent to the current
>      acpi_tb_parse_root_table().
> (2) Redefine acpi_tb_parse_root_table() as a wrapper calling those two new
>      function one right after the other.
> (3) Make Linux use the two new functions directly instead of calling
>      acpi_tb_parse_root_table()?
>
> Then, Linux will use your new functions and won't call acpi_tb_parse_root_table()
> at all, but the other existing users of ACPICA may still call it without any
> modifications.
>
> Does this make sense to you?

Thank you for you advice. It does make sense. I'll try your idea.

Thanks.



