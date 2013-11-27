Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3K0L5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:57:49 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51602 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3K0L5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:57:46 -0500
Message-ID: <5295DE36.4070508@hitachi.com>
Date: Wed, 27 Nov 2013 20:57:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/17] tracing/probes: Fix basic print type functions
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org> <1385533203-10014-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1385533203-10014-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 15:19), Namhyung Kim wrote:
>  
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
> -DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%#x")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%#x")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%#x")
> +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%#Lx")

As I said I'd like to ask you to change it in %x.

I just checked in Fedora18, but %#x is not supported on this glibc-2.17.
Since this format is exported via debugfs (format file), I think %x is
better.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


