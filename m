Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3EUJNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:13:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3EUJNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:13:45 -0400
X-IronPort-AV: E=Sophos;i="4.87,713,1363104000"; 
   d="scan'208";a="7322583"
Message-ID: <519B3B33.9020002@cn.fujitsu.com>
Date: Tue, 21 May 2013 17:15:31 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH RFC 06/48] Audit: make kauditd_task per user namespace
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com> <1367893269-9308-7-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1367893269-9308-7-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 17:12:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 17:12:27,
	Serialize complete at 2013/05/21 17:12:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 10:20 AM, Gao feng wrote:
> +	if (ns->audit.kauditd_task)
> +		kthread_stop(ns->audit.kauditd_task);

This is buggy,will trigger warning scheduling while atomic:

I will take care this problem.
