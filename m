Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbbA0RvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:51:23 -0500
Received: from g2t2353.austin.hp.com ([15.217.128.52]:55867 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbbA0RvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:51:21 -0500
Message-ID: <1422380796.6710.13.camel@j-VirtualBox>
Subject: Re: [PATCH] cgroup: Initialize root in cgroup_mount
From: Jason Low <jason.low2@hp.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, aswin@hp.com,
        jason.low2@hp.com
Date: Tue, 27 Jan 2015 09:46:36 -0800
In-Reply-To: <20150127161009.GB12314@htj.dyndns.org>
References: <1422318099.6710.3.camel@j-VirtualBox>
	 <20150127161009.GB12314@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 11:10 -0500, Tejun Heo wrote:
> On Mon, Jan 26, 2015 at 04:21:39PM -0800, Jason Low wrote:
> > Compiling kernel/ causes warnings:
> > 
> >     ... ‘root’ may be used uninitialized in this function
> >     ... ‘root’ was declared here
> > 
> > This isn't an issue since there is already logic to not use
> > root if we goto out_unlock without setting root.
> > 
> > Explicitly initialize root to NULL to suppress this so that we can
> > focus on catching warnings that can potentially cause bigger issues.
> 
> Which complier are you using?

Hi Tejun, one of the versions I am seeing this on is gcc 4.6.3.

>   The variable, AFAICS, is always set
> before being deref'd and the function hasn't triggered spurious
> warnings for quite a while with differing versions of gcc.


