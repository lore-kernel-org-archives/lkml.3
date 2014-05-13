Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaEMDxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:53:40 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51460 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaEMDxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:53:38 -0400
Message-ID: <537196D7.3020302@huawei.com>
Date: Tue, 13 May 2014 11:51:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] cgroup: update and fix parsing of "cgroup.subtree_control"
References: <1399663975-315-1-git-send-email-tj@kernel.org> <1399663975-315-5-git-send-email-tj@kernel.org>
In-Reply-To: <1399663975-315-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 35daf89..b81e7c0 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2542,11 +2542,13 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
>  	int ssid, ret;
>  
>  	/*
> -	 * Parse input - white space separated list of subsystem names
> -	 * prefixed with either + or -.
> +	 * Parse input - space separated list of subsystem names prefixed
> +	 * with either + or -.
>  	 */
>  	p = buffer;
> -	while ((tok = strsep(&p, " \t\n"))) {
> +	while ((tok = strsep(&p, " "))) {
> +		if (tok[0] =='\0')

if (tok[0] == '\0')

> +			continue;

