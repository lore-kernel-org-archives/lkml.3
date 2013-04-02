Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523Ab3DBPTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:19:03 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40715 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761435Ab3DBPTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:19:01 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <1364870780-16296-8-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1364870780-16296-1-git-send-email-liwanp@linux.vnet.ibm.com> <1364870780-16296-8-git-send-email-liwanp@linux.vnet.ibm.com>
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Tue, 2 Apr 2013 11:18:39 -0400
X-Google-Sender-Auth: GEP1HpHrCwo7QXzDATYZrNBAPVs
Message-ID: <CAPbh3rvheDqL6U4P6L++We-Ra=Cw_fNrdPGfhV3tzVA_eW5CxQ@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] staging: zcache: introduce zero-filled page stat count
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -176,6 +176,8 @@ ssize_t zcache_pers_ate_eph;
>  ssize_t zcache_pers_ate_eph_failed;
>  ssize_t zcache_evicted_eph_zpages;
>  ssize_t zcache_evicted_eph_pageframes;
> +ssize_t zcache_zero_filled_pages;
> +ssize_t zcache_zero_filled_pages_max;

Is it possible to shove these in the debug.c file? And in debug.h just
have an extern?
