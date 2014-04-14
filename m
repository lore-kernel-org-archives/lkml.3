Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaDNTVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:21:47 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:56307 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaDNTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:21:43 -0400
Date: Mon, 14 Apr 2014 15:21:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Message-ID: <20140414192139.GB16835@htj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
 <20140414154556.GA9552@redhat.com>
 <20140414175236.GB15249@htj.dyndns.org>
 <20140414181421.GC9552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414181421.GC9552@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 14, 2014 at 02:14:21PM -0400, Vivek Goyal wrote:
> So is this an intermediate mode before we move to single hiearchy *only*
> mode. AFAIK, you had mentioned that we will support legacy multiple
> hiearchy mode but single hiearchy is the new default mode.

Hmmm?  It's a separate special hierarchy which can co-exist with other
hierarchies.  There's no inherent intermediacy to it.  As long as
traditional hierarchies exist, it's gonna be like this.

> How does one figure out which one is unified hiearchy (out of multiple
> hierarchies). Is there a flag somewhere? Or sane flag will be used to
> mark unified hiearchy.

You can tell it multiple ways - from its mount options, whether
cgroup.controllers exists, but it'll most likely be mounted on a
distinctive mount point, wouldn't it?

> So task and child groups can co-exist in root *only*?

Note that the restriction doesn't apply if no controller is enabled
but yes root is the only cgroup where tasks can exist and controllers
are enabled at the same time.

Thanks.

-- 
tejun
