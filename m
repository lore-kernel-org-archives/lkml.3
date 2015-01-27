Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbbA0QKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:10:21 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39077 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbbA0QKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:10:17 -0500
Date: Tue, 27 Jan 2015 11:10:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Jason Low <jason.low2@hp.com>
Cc: Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH] cgroup: Initialize root in cgroup_mount
Message-ID: <20150127161009.GB12314@htj.dyndns.org>
References: <1422318099.6710.3.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422318099.6710.3.camel@j-VirtualBox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 04:21:39PM -0800, Jason Low wrote:
> Compiling kernel/ causes warnings:
> 
>     ... ‘root’ may be used uninitialized in this function
>     ... ‘root’ was declared here
> 
> This isn't an issue since there is already logic to not use
> root if we goto out_unlock without setting root.
> 
> Explicitly initialize root to NULL to suppress this so that we can
> focus on catching warnings that can potentially cause bigger issues.

Which complier are you using?  The variable, AFAICS, is always set
before being deref'd and the function hasn't triggered spurious
warnings for quite a while with differing versions of gcc.

Thanks.

-- 
tejun
