Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3DBPK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:10:57 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58245 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab3DBPKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:10:55 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <1364870780-16296-5-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1364870780-16296-1-git-send-email-liwanp@linux.vnet.ibm.com> <1364870780-16296-5-git-send-email-liwanp@linux.vnet.ibm.com>
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Date: Tue, 2 Apr 2013 11:10:31 -0400
X-Google-Sender-Auth: 11twcaTMTJEy9riIwogZwosqJgM
Message-ID: <CAPbh3rv08RV4Nc+tznmfb5fE-EpUaMb8Rrrrg_8pg_GiUyZPgA@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] staging: zcache: fix pers_pageframes|_max aren't
 exported in debugfs
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

On Mon, Apr 1, 2013 at 10:46 PM, Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
> Before commit 9c0ad59ef ("zcache/debug: Use an array to initialize/use debugfs attributes"),
> pers_pageframes|_max are exported in debugfs, but this commit forgot use array export
> pers_pageframes|_max. This patch add pers_pageframes|_max back.

Duh! Thanks for spotting.

Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/debug.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/zcache/debug.c b/drivers/staging/zcache/debug.c
> index e951c64..254dada 100644
> --- a/drivers/staging/zcache/debug.c
> +++ b/drivers/staging/zcache/debug.c
> @@ -21,6 +21,7 @@ static struct debug_entry {
>         ATTR(pers_ate_eph), ATTR(pers_ate_eph_failed),
>         ATTR(evicted_eph_zpages), ATTR(evicted_eph_pageframes),
>         ATTR(eph_pageframes), ATTR(eph_pageframes_max),
> +       ATTR(pers_pageframes), ATTR(pers_pageframes_max),
>         ATTR(eph_zpages), ATTR(eph_zpages_max),
>         ATTR(pers_zpages), ATTR(pers_zpages_max),
>         ATTR(last_active_file_pageframes),
> --
> 1.7.7.6
>
