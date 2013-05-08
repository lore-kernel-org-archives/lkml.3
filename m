Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3EHKjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:39:21 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47570 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3EHKjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:39:19 -0400
Message-ID: <518A2B4B.4040509@linux.vnet.ibm.com>
Date: Wed, 08 May 2013 18:39:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@calxeda.com>,
        SH-Run Zhen RZ Wang <rzwang@cn.ibm.com>
Subject: Re: [PATCH] perf tools: Fix perf version generation
References: <1368006214-12912-1-git-send-email-rric@kernel.org>
In-Reply-To: <1368006214-12912-1-git-send-email-rric@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050810-5490-0000-0000-0000036B7C43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 05:43 PM, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> The tag of the perf version is wrongly determined, always the latest
> tag is taken regardless of the HEAD commit:
> 
>  $ perf --version
>  perf version 3.9.rc8.gd7f5d3
>  $ git describe d7f5d3
>  v3.9-rc7-154-gd7f5d33
>  $ head -n 4 Makefile
>  VERSION = 3
>  PATCHLEVEL = 9
>  SUBLEVEL = 0
>  EXTRAVERSION = -rc7
> 
> In other cases no tag might be found.
> 
> This patch fixes this.
> 
> This new implementation handles also the case if there are no tags at
> all found in the git repo but there is a commit id.

I remember that Wang has posted a similar patch to fix this bug several
weeks ago:
	http://lkml.org/lkml/2013/4/24/70

But have no response yet.

