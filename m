Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3CAUj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:39:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52518 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3CAUjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 15:39:24 -0500
Date: Fri, 1 Mar 2013 20:39:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Message-ID: <20130301203917.GT4503@ZenIV.linux.org.uk>
References: <512B01FA.5020506@huawei.com>
 <512B020D.9040504@huawei.com>
 <20130226022703.GA13837@htj.dyndns.org>
 <512C8D84.7090707@huawei.com>
 <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
 <512DE4A8.5050303@huawei.com>
 <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
 <512EFEDF.8080205@huawei.com>
 <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
 <51304C6D.8050207@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51304C6D.8050207@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 02:36:29PM +0800, Li Zefan wrote:
> On 2013/2/28 22:49, Tejun Heo wrote:
> > On Wed, Feb 27, 2013 at 10:53 PM, Li Zefan <lizefan@huawei.com> wrote:
> >>> static const struct cgroup_name root_cgroup_name = { .name = "/" };
> >>
> >> Can't... That's char name[0] not char *name.
> > 
> > Flexible array members can be statically initialized. If you wanna be
> > really anal about it, you can do it manually with a wrapping struct
> > but I don't think that would be necessary.
> > 
> 
> I didn't know this difference between flexible array and zero-size array.
> Thanks.

Mind you, initializing flex array member is explicitly invalid per C99;
it's a GNU extension...
